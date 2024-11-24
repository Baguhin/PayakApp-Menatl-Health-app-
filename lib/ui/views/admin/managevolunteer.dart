// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'mental_health_expert.dart';

class ManageVolunteer extends StatefulWidget {
  const ManageVolunteer({Key? key}) : super(key: key);

  @override
  _ManageVolunteerState createState() => _ManageVolunteerState();
}

class _ManageVolunteerState extends State<ManageVolunteer> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<MentalHealthExpert> _experts = [];

  @override
  void initState() {
    super.initState();
    _fetchExperts();
  }

  // Fetch experts from Firebase Database
  Future<void> _fetchExperts() async {
    _database.child('mental_health_experts').onValue.listen((event) {
      final expertsData = event.snapshot.value as Map<dynamic, dynamic>?;

      if (expertsData != null) {
        setState(() {
          _experts = expertsData.entries.map((entry) {
            final expert = MentalHealthExpert.fromMap(entry.value);
            expert.id = entry.key; // Assign the key as the ID
            return expert;
          }).toList();
        });
      }
    });
  }

  // Add or update an expert in Firebase Database
  Future<void> _addOrUpdateExpert(MentalHealthExpert expert) async {
    try {
      if (expert.id.isEmpty) {
        // Add new expert
        await _database
            .child('mental_health_experts')
            .push()
            .set(expert.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expert added successfully.')),
        );
      } else {
        // Update existing expert
        await _database
            .child('mental_health_experts/${expert.id}')
            .set(expert.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expert updated successfully.')),
        );
      }
      // Refresh the expert list after adding/updating
      _fetchExperts();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding/updating expert: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save expert.')),
      );
    }
  }

  // Delete an expert from Firebase Database
  Future<void> _deleteExpert(String id) async {
    try {
      await _database.child('mental_health_experts/$id').remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expert deleted successfully.')),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting expert: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete expert.')),
      );
    }
  }

  Future<String> _uploadProfilePicture(XFile? image) async {
    if (image == null || image.path.isEmpty) {
      if (kDebugMode) {
        print('No image selected.');
      }
      return '';
    }

    try {
      File file = File(image.path);
      if (!await file.exists()) {
        throw Exception("File does not exist at path: ${image.path}");
      }

      String filePath =
          'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = _storage.ref().child(filePath);

      await ref
          .putFile(file)
          .timeout(const Duration(seconds: 120)); // Increased timeout

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (e is FirebaseException) {
        if (kDebugMode) {
          print('Firebase error: ${e.code} - ${e.message}');
        }
      } else {
        if (kDebugMode) {
          print('Error uploading profile picture: $e');
        }
      }
      return '';
    }
  }

  // Show the expert form dialog for adding or editing experts
  void _showExpertForm({MentalHealthExpert? expert}) async {
    final isEditing = expert != null;

    final nameController = TextEditingController(text: expert?.name ?? '');
    final positionController =
        TextEditingController(text: expert?.position ?? '');
    final experienceController =
        TextEditingController(text: expert?.experience ?? '');
    final contactController =
        TextEditingController(text: expert?.contact ?? '');
    final profilePictureUrlController =
        TextEditingController(text: expert?.profilePictureUrl ?? '');

    String? uploadedImageUrl; // Track uploaded image URL

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Expert' : 'Add Expert'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: 'Position'),
                ),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(labelText: 'Experience'),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: profilePictureUrlController,
                        decoration: const InputDecoration(
                            labelText: 'Profile Picture URL'),
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          String url = await _uploadProfilePicture(pickedFile);
                          if (url.isNotEmpty) {
                            uploadedImageUrl = url; // Store the uploaded URL
                            profilePictureUrlController.text =
                                url; // Set the URL in the controller
                          } else {
                            // Handle the case where the upload failed
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to upload image.')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Validate input before saving
                if (nameController.text.isEmpty ||
                    positionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                  return;
                }

                final expertData = MentalHealthExpert(
                  id: isEditing ? expert.id : '', // Use expert safely
                  name: nameController.text,
                  position: positionController.text,
                  experience: experienceController.text,
                  contact: contactController.text,
                  profilePictureUrl:
                      uploadedImageUrl ?? // Use uploaded URL if available
                          profilePictureUrlController.text,
                );

                _addOrUpdateExpert(expertData);
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Volunteers')),
      body: _experts.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator if no experts are fetched
          : ListView.builder(
              itemCount: _experts.length,
              itemBuilder: (context, index) {
                final expert = _experts[index];
                return ListTile(
                  leading: expert.profilePictureUrl.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(expert.profilePictureUrl),
                        )
                      : const CircleAvatar(
                          child: Icon(
                              Icons.person)), // Placeholder icon if no picture
                  title: Text(expert.name),
                  subtitle: Text(expert.position),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showExpertForm(expert: expert),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteExpert(expert.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpertForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
