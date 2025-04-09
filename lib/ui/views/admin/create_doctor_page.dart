import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import 'admin_doctor.dart';

class CreateDoctorPage extends StatefulWidget {
  const CreateDoctorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateDoctorPageState createState() => _CreateDoctorPageState();
}

class _CreateDoctorPageState extends State<CreateDoctorPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final dio.Dio _dio = dio.Dio();
  bool isLoading = false;

  final String apiUrl = 'https://legit-backend-iqvk.onrender.com/doctors';
  bool isFormValid = false;

  // Specializations list for dropdown
  final List<String> specializations = [
    'Psychiatry',
    'Psychology',
    'Counseling',
    'Therapy',
    'Cognitive Behavioral Therapy (CBT)',
    'Marriage and Family Therapy',
    'Addiction Counseling',
    'Grief Counseling',
    'Child and Adolescent Psychiatry',
    'Trauma Therapy',
    'Mindfulness Coaching',
    'Behavioral Therapy',
    'Stress Management',
    'Anger Management',
    'Bisu Peer Facilatator',
    'Other'
  ];

  String? selectedSpecialization;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    ratingController.addListener(_validateForm);
    // Initialize rating with a default value
    ratingController.text = '3.0';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    specializationController.dispose();
    emailController.dispose();
    addressController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isFormValid = nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          (selectedSpecialization != null ||
              specializationController.text.isNotEmpty) &&
          emailController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          ratingController.text.isNotEmpty &&
          double.tryParse(ratingController.text) != null &&
          double.parse(ratingController.text) >= 1 &&
          double.parse(ratingController.text) <= 5;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _validateForm();
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _validateForm();
      });
    }
  }

  Future<void> _createDoctor() async {
    if (!isFormValid || !_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'specialization':
            selectedSpecialization ?? specializationController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'rating': ratingController.text.trim(),
      });

      if (_image != null) {
        String fileName = _image!.path.split('/').last;
        String mimeType = lookupMimeType(_image!.path) ?? 'image/jpeg';
        final mimeTypeData = mimeType.split('/');

        formData.files.add(MapEntry(
          "image",
          await dio.MultipartFile.fromFile(
            _image!.path,
            filename: fileName,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        ));
      }

      dio.Response response = await _dio.post(
        apiUrl,
        data: formData,
        options: dio.Options(
          headers: {'Content-Type': 'multipart/form-data'},
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Success",
            "Doctor added successfully",
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        });

        _resetForm();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Error",
            "Failed: ${response.statusCode} - ${response.data['error'] ?? 'Unknown error'}",
            backgroundColor: Colors.red.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.error, color: Colors.white),
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      Future.microtask(() {
        if (mounted) {
          // Check if widget is still mounted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text("Failed to create doctor: $e")),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  void _resetForm() {
    nameController.clear();
    phoneController.clear();
    specializationController.clear();
    emailController.clear();
    addressController.clear();
    ratingController.text = '3.0'; // Reset to default value
    setState(() {
      _image = null;
      isFormValid = false;
      selectedSpecialization = null;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Add New Doctor",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
            tooltip: "Manage Doctors",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminDoctorPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Doctor profile image
                      GestureDetector(
                        onTap: _showImagePickerOptions,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _image == null
                              ? Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 50,
                                  color: Colors.teal[700],
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _showImagePickerOptions,
                        icon: Icon(Icons.photo_library_rounded,
                            color: Colors.teal[700]),
                        label: Text(
                          "Upload Photo",
                          style: TextStyle(color: Colors.teal[700]),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Form section with card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Doctor Information",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const Divider(height: 25),

                              _buildTextField(
                                nameController,
                                "Full Name",
                                Icons.person_rounded,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),

                              _buildTextField(
                                phoneController,
                                "Phone Number",
                                Icons.phone_rounded,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  return null;
                                },
                              ),

                              // Specialization dropdown
                              _buildSpecializationField(),

                              _buildTextField(
                                emailController,
                                "Email Address",
                                Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              _buildTextField(
                                addressController,
                                "Office Address",
                                Icons.location_on_rounded,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                              ),

                              _buildRatingSlider(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Create Doctor Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isFormValid ? _createDoctor : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFormValid
                                ? Colors.teal[700]
                                : Colors.grey[400],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_circle_outline_rounded),
                              const SizedBox(width: 10),
                              Text(
                                "Create Doctor Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Reset Form Button
                      TextButton.icon(
                        onPressed: _resetForm,
                        icon: const Icon(Icons.refresh, color: Colors.grey),
                        label: const Text(
                          "Reset Form",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Profile Photo",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.camera_alt_rounded,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_image != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _image = null;
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "Remove Current Photo",
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.teal[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: "Enter $label",
          prefixIcon: Icon(icon, color: Colors.teal[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal[700]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  void _showCustomSpecializationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController customController = TextEditingController();

        return AlertDialog(
          title: const Text("Custom Specialization"),
          content: TextField(
            controller: customController,
            decoration: const InputDecoration(
              hintText: "Enter specialization",
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final input = customController.text?.trim();
                if (input?.isNotEmpty ?? false) {
                  setState(() {
                    selectedSpecialization = "Other";
                    specializationController.text = input!;
                    _validateForm();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpecializationField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedSpecialization,
        hint: const Text("Select Specialization"),
        isExpanded: true, // Make dropdown use full width
        validator: (value) {
          if ((value == null || value.isEmpty) &&
              specializationController.text.isEmpty) {
            return 'Specialization is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Specialization",
          prefixIcon:
              Icon(Icons.medical_services_rounded, color: Colors.teal[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal[700]!, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        items: specializations.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // Handle text overflow
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedSpecialization = newValue;
            if (newValue == "Other") {
              _showCustomSpecializationDialog();
            } else {
              specializationController.text = newValue ?? '';
              _validateForm();
            }
          });
        },
      ),
    );
  }

  Widget _buildRatingSlider() {
    // Current rating value
    double currentRating = double.tryParse(ratingController.text) ?? 3.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Doctor Rating",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    currentRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.teal[700],
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.teal[700],
            overlayColor: Colors.teal.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8,
              pressedElevation: 4,
            ),
          ),
          child: Slider(
            min: 1.0,
            max: 5.0,
            divisions: 8,
            value: currentRating,
            onChanged: (value) {
              setState(() {
                ratingController.text = value.toStringAsFixed(1);
                _validateForm();
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("1.0", style: TextStyle(color: Colors.grey)),
            Text("5.0", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
