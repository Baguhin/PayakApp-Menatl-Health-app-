// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ExpertManagementPage extends StatefulWidget {
  const ExpertManagementPage({super.key});

  @override
  _ExpertManagementPageState createState() => _ExpertManagementPageState();
}

class _ExpertManagementPageState extends State<ExpertManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  List<MentalHealthExpert> experts = [];
  String? name;
  String? skill;
  String? imageUrl;
  int experienceYears = 0; // Changed to int
  String? location;
  String? phone;
  int review = 0;
  int successfulPatients = 0;

  @override
  void initState() {
    super.initState();
    _loadExperts();
  }

  Future<void> _loadExperts() async {
    final snapshot = await _firestore.collection('experts').get();
    setState(() {
      experts = snapshot.docs
          .map((doc) => MentalHealthExpert.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> _addExpert() async {
    if (name != null && skill != null && imageUrl != null) {
      final expert = MentalHealthExpert(
        name: name!,
        skill: skill!,
        imageUrl: imageUrl!,
        review: review,
        successfulPatients: successfulPatients,
        experience: experienceYears.toString(), // Store as string
        location: location ?? '',
        phone: phone ?? '',
        id: '',
      );

      await _firestore.collection('experts').add(expert.toMap());
      _clearFields();
      _loadExperts();
    }
  }

  Future<void> _updateExpert(String id) async {
    final expert = MentalHealthExpert(
      name: name!,
      skill: skill!,
      imageUrl: imageUrl!,
      review: review,
      successfulPatients: successfulPatients,
      experience: experienceYears.toString(), // Store as string
      location: location ?? '',
      phone: phone ?? '',
      id: id,
    );

    await _firestore.collection('experts').doc(id).update(expert.toMap());
    _clearFields();
    _loadExperts();
  }

  Future<void> _deleteExpert(String id) async {
    await _firestore.collection('experts').doc(id).delete();
    _loadExperts();
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path; // Store local path
      });
    }
  }

  void _clearFields() {
    name = null;
    skill = null;
    imageUrl = null;
    experienceYears = 0; // Reset experience
    location = null;
    phone = null;
    review = 0;
    successfulPatients = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Mental Health Experts'),
        backgroundColor: Colors.teal, // Theme color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent.withOpacity(0.3), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: experts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              (experts[index].imageUrl.startsWith('/')
                                  ? FileImage(File(experts[index].imageUrl))
                                      as ImageProvider<Object>
                                  : NetworkImage(experts[index].imageUrl)
                                      as ImageProvider<Object>),
                        ),
                        title: Text(experts[index].name),
                        subtitle: Text(
                          '${experts[index].skill}\n${experts[index].location}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  // Load the expert data into the fields for editing
                                  name = experts[index].name;
                                  skill = experts[index].skill;
                                  imageUrl = experts[index].imageUrl;
                                  review = experts[index].review;
                                  successfulPatients =
                                      experts[index].successfulPatients;
                                  experienceYears =
                                      int.parse(experts[index].experience);
                                  location = experts[index].location;
                                  phone = experts[index].phone;
                                });
                                _showExpertForm(context, experts[index].id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteExpert(experts[index].id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showExpertForm(
                        context, null); // null for adding new expert
                  },
                  child: const Text('Add Expert'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExpertForm(BuildContext context, String? expertId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Skill'),
                  onChanged: (value) => skill = value,
                ),
                Row(
                  children: [
                    const Text('Experience (Years): '),
                    DropdownButton<int>(
                      value: experienceYears,
                      items: List.generate(
                        21, // Example: 0 to 20 years
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(index.toString()),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        experienceYears = value!;
                      }),
                    ),
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Location'),
                  onChanged: (value) => location = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Phone'),
                  onChanged: (value) => phone = value,
                ),
                Row(
                  children: [
                    const Text('Review: '),
                    DropdownButton<int>(
                      value: review,
                      items: List.generate(
                        6,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(index.toString()),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        review = value!;
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Successful Patients: '),
                    DropdownButton<int>(
                      value: successfulPatients,
                      items: List.generate(
                        101,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text(index.toString()),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        successfulPatients = value!;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: const Text('Upload Profile Picture'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (name != null && skill != null && imageUrl != null) {
                      if (expertId != null) {
                        // Update the expert
                        _updateExpert(expertId);
                      } else {
                        // Add a new expert
                        _addExpert();
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MentalHealthExpert {
  final String id;
  final String name;
  final String skill;
  final String imageUrl;
  final int review;
  final int successfulPatients;
  final String experience;
  final String location;
  final String phone;

  MentalHealthExpert({
    required this.id,
    required this.name,
    required this.skill,
    required this.imageUrl,
    required this.review,
    required this.successfulPatients,
    required this.experience,
    required this.location,
    required this.phone,
  });

  factory MentalHealthExpert.fromMap(Map<String, dynamic> data, String id) {
    return MentalHealthExpert(
      id: id,
      name: data['name'],
      skill: data['skill'],
      imageUrl: data['imageUrl'],
      review: data['review'],
      successfulPatients: data['successfulPatients'],
      experience: data['experience'],
      location: data['location'],
      phone: data['phone'],
    );
  }

  get image => null;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'skill': skill,
      'imageUrl': imageUrl,
      'review': review,
      'successfulPatients': successfulPatients,
      'experience': experience,
      'location': location,
      'phone': phone,
    };
  }
}
