// ignore_for_file: library_private_types_in_public_api, unnecessary_import

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewAppFeedbackPage extends StatefulWidget {
  const ViewAppFeedbackPage({Key? key}) : super(key: key);

  @override
  _ViewAppFeedbackPageState createState() => _ViewAppFeedbackPageState();
}

class _ViewAppFeedbackPageState extends State<ViewAppFeedbackPage> {
  final DatabaseReference _feedbackRef =
      FirebaseDatabase.instance.ref().child('feedback');
  late final StreamSubscription<DatabaseEvent> _feedbackSubscription;
  List<Map<String, dynamic>> feedbackList = [];

  @override
  void initState() {
    super.initState();
    _listenToFeedback();
  }

  void _listenToFeedback() {
    _feedbackSubscription = _feedbackRef.onValue.listen((event) {
      final data = event.snapshot.value;

      // Check if data is not null and is of type Map
      if (data != null && data is Map<dynamic, dynamic>) {
        setState(() {
          feedbackList = data.entries
              .map((entry) {
                final feedbackData = entry.value;

                // Only process feedback of type "App Feedback"
                if (feedbackData is Map<dynamic, dynamic> &&
                    feedbackData['type'] == 'App Feedback') {
                  return {
                    'key': entry.key,
                    'feedback': feedbackData['feedback'],
                    'timestamp': feedbackData['timestamp'],
                  };
                }
                return null; // Return null for non-app feedback
              })
              .where((feedback) =>
                  feedback != null &&
                  feedback['feedback'] != null &&
                  feedback['timestamp'] != null)
              .cast<Map<String, dynamic>>()
              .toList();
        });
      } else {
        setState(() {
          feedbackList.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    _feedbackSubscription.cancel(); // Cancel the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View App Feedback'),
        backgroundColor: const Color(0xFF6D8DAD), // Soft calming blue
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFECEFF1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: feedbackList.isEmpty
            ? const Center(
                child: Text(
                  'No app feedback submitted yet.',
                  style: TextStyle(fontSize: 18, color: Color(0xFF62757F)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.grey.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.feedback,
                                    color: Color(0xFF4A6572), // Calming icon
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      feedback['feedback'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A6572),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Submitted on: ${feedback['timestamp']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF62757F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
