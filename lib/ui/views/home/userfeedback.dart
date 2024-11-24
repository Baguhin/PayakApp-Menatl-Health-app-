// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('feedback');

  String _feedbackType = 'App Feedback'; // Default feedback type

  void _submitFeedback() {
    String feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      _database.push().set({
        'feedback': feedback,
        'timestamp': DateTime.now().toIso8601String(),
        'type': _feedbackType,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thank you for your feedback!')));
        _feedbackController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: const Color(0xFF6D8DAD),
        centerTitle: true,
        elevation: 0, // Flat app bar
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFECEFF1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // Increased overall padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Thoughts Matter!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6572),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'We value your feedback. It helps us improve our mental health services and create a better experience for everyone.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF62757F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Feedback Type Dropdown with Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.feedback, color: Color(0xFF4A6572)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _feedbackType,
                    onChanged: (String? newValue) {
                      setState(() {
                        _feedbackType = newValue!;
                      });
                    },
                    items: <String>['App Feedback', 'Service Feedback']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Feedback Input Field with Soft Borders
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Your feedback...',
                    labelStyle: const TextStyle(color: Color(0xFF4A6572)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none, // Remove border line
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF4A6572)),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  maxLines: 5,
                  style: const TextStyle(color: Color(0xFF4A6572)),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button with Rounded Corners
              ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D8DAD),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Your feedback helps us make a difference!',
                style: TextStyle(
                  color: Color(0xFF4A6572),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
