// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateSeminarPage extends StatefulWidget {
  const CreateSeminarPage({super.key});

  @override
  _CreateSeminarPageState createState() => _CreateSeminarPageState();
}

class _CreateSeminarPageState extends State<CreateSeminarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
            'topic': _topicController.text,
            'capacity': int.parse(_capacityController.text),
            'location': _locationController.text,
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Seminar created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Failed to create seminar');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating seminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
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
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration:
                              _getInputDecoration('Seminar Title', Icons.title),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter a title'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: _getInputDecoration(
                              'Description', Icons.description),
                          maxLines: 3,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter a description'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _dateController,
                                decoration: _getInputDecoration(
                                        'Date', Icons.calendar_today)
                                    .copyWith(
                                        suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
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
                                  icon: const Icon(Icons.access_time),
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
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _durationController,
                          decoration: _getInputDecoration(
                              'Duration (minutes)', Icons.timer),
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter duration'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _instructorController,
                          decoration:
                              _getInputDecoration('Instructor', Icons.person),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter instructor name'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _topicController,
                          decoration: _getInputDecoration('Topic', Icons.topic),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter a topic'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _capacityController,
                          decoration:
                              _getInputDecoration('Capacity', Icons.group),
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter capacity'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _locationController,
                          decoration: _getInputDecoration(
                              'Location', Icons.location_on),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter a location'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _createSeminar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Create Seminar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
