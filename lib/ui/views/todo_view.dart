import 'package:flutter/material.dart';

class TodoView extends StatelessWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do'),
        backgroundColor: const Color(0xFF6D3D91), // Dark Purple
      ),
      body: const Center(
        child: Text(
          'You have a meditation session scheduled for 3:00 PM.',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
