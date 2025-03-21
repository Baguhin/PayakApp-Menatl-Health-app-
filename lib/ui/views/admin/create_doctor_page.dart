import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CreateDoctorPage extends StatefulWidget {
  const CreateDoctorPage({super.key});

  @override
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

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final dio.Dio _dio = dio.Dio();

  final String apiUrl =
      'http://192.168.43.161:5000/doctors'; // Change IP if needed
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    specializationController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    ratingController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isFormValid = nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          specializationController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          ratingController.text.isNotEmpty &&
          double.tryParse(ratingController.text) != null &&
          double.parse(ratingController.text) >= 1 &&
          double.parse(ratingController.text) <= 5;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _validateForm();
      });
    }
  }

  Future<void> _createDoctor() async {
    if (!isFormValid) return;

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'name': nameController.text,
        'phone': phoneController.text,
        'specialization': specializationController.text,
        'email': emailController.text,
        'address': addressController.text,
        'rating': ratingController.text,
      });

      if (_image != null) {
        String fileName = _image!.path.split('/').last;
        String? mimeType = lookupMimeType(_image!.path);
        final mimeTypeData = mimeType?.split('/') ?? ['image', 'jpeg'];

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
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Doctor added successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
        nameController.clear();
        phoneController.clear();
        specializationController.clear();
        emailController.clear();
        addressController.clear();
        ratingController.clear();
        setState(() {
          _image = null;
          isFormValid = false;
        });
      } else {
        Get.snackbar("Error", "Failed: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to create doctor: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Add Doctor",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[400],
        centerTitle: true,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(nameController, "Name", Icons.person),
            _buildTextField(phoneController, "Phone", Icons.phone),
            _buildTextField(
                specializationController, "Specialization", Icons.work),
            _buildTextField(emailController, "Email", Icons.email),
            _buildTextField(addressController, "Address", Icons.location_on),
            _buildTextField(ratingController, "Rating (1-5)", Icons.star,
                keyboardType: TextInputType.number),

            const SizedBox(height: 15),

            // Image Picker with Preview
            _image != null
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                : Container(),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Pick Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            const SizedBox(height: 15),

            // Create Doctor Button
            ElevatedButton(
              onPressed: isFormValid ? _createDoctor : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid ? Colors.teal[600] : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text("Create Doctor",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
