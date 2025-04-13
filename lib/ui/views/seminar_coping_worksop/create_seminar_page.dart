// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateMentalHealthSeminarPage extends StatefulWidget {
  const CreateMentalHealthSeminarPage({super.key});

  @override
  _CreateMentalHealthSeminarPageState createState() =>
      _CreateMentalHealthSeminarPageState();
}

class _CreateMentalHealthSeminarPageState
    extends State<CreateMentalHealthSeminarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _qualificationsController =
      TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _targetAudienceController =
      TextEditingController();
  final TextEditingController _resourcesController = TextEditingController();

  String _selectedMentalHealthTopic = 'Anxiety';
  bool _isOnline = false;
  bool _providesResources = false;
  bool _requiresPrerequisites = false;
  bool _isLoading = false;
  bool _offersCertificate = false;

  final List<String> _mentalHealthTopics = [
    'Anxiety',
    'Depression',
    'Stress Management',
    'Burnout Prevention',
    'Trauma-Informed Care',
    'Mindfulness',
    'Cognitive Behavioral Techniques',
    'Self-Care Practices',
    'Crisis Intervention',
    'Workplace Mental Health',
    'Student Mental Health',
    'Grief and Loss',
    'Substance Use Support',
    'Emotional Intelligence',
    'Other'
  ];

  List<String> _supportOptions = [];
  final List<String> _availableSupportOptions = [
    'One-on-one counseling follow-up',
    'Resource materials',
    'Online community access',
    'Mobile app support',
    'Post-seminar check-ins',
    'Professional referral network'
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C63FF), // Custom primary color
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C63FF), // Custom primary color
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _createSeminar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('https://legit-backend-iqvk.onrender.com/api/seminars'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'title': _titleController.text,
            'description': _descriptionController.text,
            'date': _dateController.text,
            'time': _timeController.text,
            'duration': int.parse(_durationController.text),
            'instructor': _instructorController.text,
            'topic': _selectedMentalHealthTopic,
            'capacity': int.parse(_capacityController.text),
            'location': _isOnline ? 'Online' : _locationController.text,
            'isOnline': _isOnline,
            'qualifications': _qualificationsController.text,
            'targetAudience': _targetAudienceController.text,
            'providesResources': _providesResources,
            'resources': _resourcesController.text,
            'requiresPrerequisites': _requiresPrerequisites,
            'supportOptions': _supportOptions,
            'offersCertificate': _offersCertificate,
          }),
        );

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201) {
          _showSuccessDialog();
        } else {
          throw Exception('Failed to create seminar: ${response.body}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating seminar: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Success!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Your mental health seminar "${_titleController.text}" has been created successfully.'),
              const SizedBox(height: 16),
              const Text('What would you like to do next?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: const Text('Return to Dashboard'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Clear form for a new seminar
                _formKey.currentState!.reset();
                _titleController.clear();
                _descriptionController.clear();
                _dateController.clear();
                _timeController.clear();
                _durationController.clear();
                _instructorController.clear();
                _qualificationsController.clear();
                _capacityController.clear();
                _locationController.clear();
                _targetAudienceController.clear();
                _resourcesController.clear();
                setState(() {
                  _selectedMentalHealthTopic = 'Anxiety';
                  _isOnline = false;
                  _providesResources = false;
                  _requiresPrerequisites = false;
                  _offersCertificate = false;
                  _supportOptions = [];
                });
                Navigator.of(context).pop();
              },
              child: const Text('Create Another Seminar'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _getInputDecoration(String label, IconData icon,
      {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Seminar'),
        elevation: 0,
        backgroundColor: const Color(0xFF6C63FF),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFFEEEAFF), Colors.white],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Seminar illustration or icon
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: 70,
                          color: const Color(0xFF6C63FF),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title section with description
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seminar Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a mental health seminar to provide valuable information and resources to your community.',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _titleController,
                            decoration: _getInputDecoration(
                              'Seminar Title',
                              Icons.title,
                              hintText: 'E.g., Managing Anxiety in Daily Life',
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter a title'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: _getInputDecoration(
                              'Description',
                              Icons.description,
                              hintText:
                                  'Describe what participants will learn and experience',
                            ),
                            maxLines: 4,
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter a description'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: _selectedMentalHealthTopic,
                              decoration: _getInputDecoration(
                                'Mental Health Topic',
                                Icons.category,
                              ),
                              items: _mentalHealthTopics
                                  .map((String topic) =>
                                      DropdownMenuItem<String>(
                                        value: topic,
                                        child: Text(
                                          topic,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedMentalHealthTopic = newValue;
                                  });
                                }
                              },
                              validator: (value) => value == null
                                  ? 'Please select a topic'
                                  : null,
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Schedule and location section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Schedule & Location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: _getInputDecoration(
                                          'Date', Icons.calendar_today)
                                      .copyWith(
                                          suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today,
                                        color: Color(0xFF6C63FF)),
                                    onPressed: _selectDate,
                                  )),
                                  readOnly: true,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Please select a date'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _timeController,
                                  decoration: _getInputDecoration(
                                          'Time', Icons.access_time)
                                      .copyWith(
                                          suffixIcon: IconButton(
                                    icon: const Icon(Icons.access_time,
                                        color: Color(0xFF6C63FF)),
                                    onPressed: _selectTime,
                                  )),
                                  readOnly: true,
                                  validator: (value) => value?.isEmpty ?? true
                                      ? 'Please select a time'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _durationController,
                            decoration: _getInputDecoration(
                              'Duration (minutes)',
                              Icons.timer,
                              hintText: 'E.g., 90',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter duration'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('This is an online seminar'),
                            value: _isOnline,
                            activeColor: const Color(0xFF6C63FF),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool value) {
                              setState(() {
                                _isOnline = value;
                              });
                            },
                          ),
                          if (!_isOnline)
                            TextFormField(
                              controller: _locationController,
                              decoration: _getInputDecoration(
                                'Physical Location',
                                Icons.location_on,
                                hintText: 'Address or venue name',
                              ),
                              validator: (value) =>
                                  !_isOnline && (value?.isEmpty ?? true)
                                      ? 'Please enter a location'
                                      : null,
                            ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _capacityController,
                            decoration: _getInputDecoration(
                              'Capacity',
                              Icons.group,
                              hintText: 'Maximum number of participants',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter capacity'
                                : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instructor information
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Presenter Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _instructorController,
                            decoration: _getInputDecoration(
                              'Presenter Name',
                              Icons.person,
                              hintText: 'Full name of the presenter',
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter presenter name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _qualificationsController,
                            decoration: _getInputDecoration(
                              'Qualifications & Credentials',
                              Icons.verified,
                              hintText:
                                  'E.g., Licensed Therapist, Ph.D. in Psychology',
                            ),
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Please enter qualifications'
                                : null,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Additional seminar details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Additional Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _targetAudienceController,
                            decoration: _getInputDecoration(
                              'Target Audience',
                              Icons.people,
                              hintText:
                                  'E.g., Working professionals, Students, Healthcare workers',
                            ),
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Provides take-home resources'),
                            value: _providesResources,
                            activeColor: const Color(0xFF6C63FF),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool value) {
                              setState(() {
                                _providesResources = value;
                              });
                            },
                          ),
                          if (_providesResources)
                            TextFormField(
                              controller: _resourcesController,
                              decoration: _getInputDecoration(
                                'Resource Details',
                                Icons.article,
                                hintText:
                                    'Describe the resources participants will receive',
                              ),
                              maxLines: 2,
                            ),
                          SwitchListTile(
                            title: const Text('Requires prerequisites'),
                            value: _requiresPrerequisites,
                            activeColor: const Color(0xFF6C63FF),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool value) {
                              setState(() {
                                _requiresPrerequisites = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            title:
                                const Text('Offers certificate of completion'),
                            value: _offersCertificate,
                            activeColor: const Color(0xFF6C63FF),
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool value) {
                              setState(() {
                                _offersCertificate = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Post-Seminar Support Options',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children:
                                _availableSupportOptions.map((String option) {
                              final isSelected =
                                  _supportOptions.contains(option);
                              return FilterChip(
                                label: Text(option),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      _supportOptions.add(option);
                                    } else {
                                      _supportOptions.remove(option);
                                    }
                                  });
                                },
                                backgroundColor: Colors.grey[100],
                                selectedColor: const Color(0xFFDCD6FF),
                                checkmarkColor: const Color(0xFF6C63FF),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF6C63FF)
                                      : Colors.black87,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _createSeminar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'eminar',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6C63FF),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
