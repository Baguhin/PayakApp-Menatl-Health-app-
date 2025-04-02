import 'package:flutter/material.dart';
import '../data/data.dart';
import '../models/course.dart';
import 'exercise_details.dart';

class Courses extends StatelessWidget {
  const Courses({Key? key}) : super(key: key);

  Widget _buildCourses(BuildContext context, int index) {
    Course course = courses[index];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Image.asset(course.imageUrl, width: 80, fit: BoxFit.cover),
        title: Text(course.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${course.students} students - ${course.time} min"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseDetailsScreen(course: course),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Exercises',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) => _buildCourses(context, index),
        ),
      ],
    );
  }
}
