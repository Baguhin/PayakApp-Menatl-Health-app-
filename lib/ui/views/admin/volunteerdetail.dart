import 'package:flutter/material.dart';
import 'package:tangullo/data/volunter.dart';

class VolunteerDetailPage extends StatelessWidget {
  final Volunteer volunteer;

  const VolunteerDetailPage({Key? key, required this.volunteer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(volunteer.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(volunteer.profilePictureUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Name: ${volunteer.name}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Experience: ${volunteer.experience}'),
          ),
          // Add more fields and edit functionalities if needed
        ],
      ),
    );
  }
}
