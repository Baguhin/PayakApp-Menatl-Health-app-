import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/assesment/adhd.dart';
import 'package:tangullo/ui/views/assesment/anxietytest.dart';
import 'package:tangullo/ui/views/assesment/bipolar.dart';
import 'package:tangullo/ui/views/assesment/depression.dart';
import 'package:tangullo/ui/views/assesment/eating.dart';
import 'package:tangullo/ui/views/assesment/ocdtest.dart';
import 'package:tangullo/ui/views/assesment/ptsd.dart';
import 'package:tangullo/ui/views/assesment/stress.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> tests = [
    {
      'name': 'Depression Test',
      'route': '/test/depression',
      'icon': 'assets/icons/depression.png'
    },
    {
      'name': 'Anxiety Test',
      'route': '/test/anxiety',
      'icon': 'assets/icons/anxiety.png'
    },
    {'name': 'OCD Test', 'route': '/test/ocd', 'icon': 'assets/icons/ocd.png'},
    {
      'name': 'Stress Test',
      'route': '/test/stress',
      'icon': 'assets/icons/stress.png'
    },
    {
      'name': 'Bipolar Disorder Test',
      'route': '/test/bipolar',
      'icon': 'assets/icons/bipolar.png'
    },
    {
      'name': 'PTSD Test',
      'route': '/test/ptsd',
      'icon': 'assets/icons/ptsd.png'
    },
    {
      'name': 'Eating Disorder Test',
      'route': '/test/eating',
      'icon': 'assets/icons/eating.png'
    },
    {
      'name': 'ADHD Test',
      'route': '/test/adhd',
      'icon': 'assets/icons/adhd.png'
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.blue.shade200, // Calming blue with a softer tone
        title: const Text(
          'PayakApp Assessment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28, // Larger font size for better readability
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins', // Friendly and readable font
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Mental health is essential for our overall well-being. Here, you can take various tests to assess your mental health condition. Below are some of the tests you can take:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, tests[index]['route']!);
                    },
                    child: Card(
                      elevation:
                          8, // Increased shadow for a more pronounced effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Rounded corners for a soft feel
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade100,
                              Colors.blue.shade100
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: Image.asset(
                            tests[index]['icon']!, // Custom icons for each test
                            height: 40.0,
                          ),
                          title: Text(
                            tests[index]['name']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios, // Arrow for better UX
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    routes: {
      '/test/depression': (context) => const DepressionTestScreen(),
      '/test/anxiety': (context) => AnxietyTestScreen(),
      '/test/ocd': (context) => const OCDTestScreen(),
      '/test/stress': (context) => StressTestScreen(),
      '/test/bipolar': (context) => const BipolarTestScreen(),
      '/test/ptsd': (context) => const PTSDTestScreen(),
      '/test/eating': (context) => const EatingDisorderTestScreen(),
      '/test/adhd': (context) => const ADHDTestScreen(),
    },
  ));
}
