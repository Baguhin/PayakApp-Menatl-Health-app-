import 'package:flutter/material.dart';

class MentalHealthSeminarAnnouncementsView extends StatelessWidget {
  const MentalHealthSeminarAnnouncementsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Seminar Announcements'),
        backgroundColor: Colors.teal.shade400,
      ),
      body: const Center(
        child: Text(
          'Here you can manage seminar announcements for mental health.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
