import 'dart:io';
import 'package:flutter/material.dart';

import 'components/courses.dart';
import 'components/diff_styles.dart';
import 'components/video_suggestions.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          "Meditate Training",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          Icon(
            Platform.isAndroid ? Icons.more_vert : Icons.more_horiz,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: ListView(
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
              children: <Widget>[
                VideoSuggestions(),
                DiffStyles(),
                Courses(),
                SizedBox(height: 80),
              ],
            ),
          )
        ],
      ),
    );
  }
}
