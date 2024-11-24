// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

class managereportPage extends StatelessWidget {
  const managereportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reports'),
      ),
      body: const Center(
        child: Text('This is the View Reports Page'),
      ),
    );
  }
}
