import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../survey_results/assestment.dart';

class StressTestScreen extends StatefulWidget {
  const StressTestScreen({Key? key}) : super(key: key);

  @override
  _StressTestScreenState createState() => _StressTestScreenState();
}

class _StressTestScreenState extends State<StressTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          "In the past month, how often have you felt overwhelmed by the demands of daily life?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "How often do you feel unable to control important things in your life?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you frequently feel nervous, anxious, or on edge without a clear reason?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Over the past month, how often have you felt that things were not going your way?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you often find it difficult to relax or unwind, even during your free time?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "How often do you feel irritable, frustrated, or easily annoyed due to stress?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you been experiencing headaches, muscle tension, or other physical symptoms due to stress?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you have trouble sleeping due to worrying or overthinking about problems in your life?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you feel like you lack support from friends, family, or loved ones when dealing with stress?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Does stress interfere with your ability to focus, make decisions, or complete daily tasks effectively?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
  ];

  Map<int, int> selectedOptions = {};
  bool isLoading = false;

  Future<void> analyzeADHDTest() async {
    setState(() => isLoading = true);

    try {
      List<String> userResponses = selectedOptions.entries.map((entry) {
        int questionIndex = entry.key;
        int optionIndex = entry.value;
        return "Q${questionIndex + 1}: ${questions[questionIndex]['question']} - ${questions[questionIndex]['options'][optionIndex]}";
      }).toList();

      final response = await http.post(
        Uri.parse('http://192.168.212.120:5000/api/stress/analyze-stress'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'responses': userResponses}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => isLoading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ADHDResultScreen(
              conclusion:
                  data['conclusion']?.toString() ?? "No conclusion available",
              explanation:
                  data['explanation']?.toString() ?? "No explanation available",
              suggestions:
                  data['suggestions']?.toString() ?? "No suggestions available",
              important: data['important']?.toString() ??
                  "No important considerations available",
              disclaimer:
                  data['disclaimer']?.toString() ?? "No disclaimer available",
            ),
          ),
        );
      } else {
        throw Exception('Failed to analyze Stress responses.');
      }
    } catch (error) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error analyzing test. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Self-Assessment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questions[index]['question'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: List.generate(
                                  questions[index]['options'].length,
                                  (optionIndex) {
                                    return RadioListTile<int>(
                                      title: Text(questions[index]['options']
                                          [optionIndex]),
                                      value: optionIndex,
                                      groupValue: selectedOptions[index],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOptions[index] = value!;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: selectedOptions.length < questions.length
                        ? null
                        : analyzeADHDTest,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
    );
  }
}
