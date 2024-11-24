import 'package:flutter/material.dart';

class ManageMentalHealthAnnouncementsView extends StatelessWidget {
  const ManageMentalHealthAnnouncementsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Mental Health Announcements'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: const Center(
        child: Text(
          'Here you can manage mental health announcements.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
