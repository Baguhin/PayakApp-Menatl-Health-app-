import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../survey_results/assestment.dart';

class OCDTestScreen extends StatefulWidget {
  const OCDTestScreen({super.key});

  @override
  _OCDTestScreenState createState() => _OCDTestScreenState();
}

class _OCDTestScreenState extends State<OCDTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          "Do you have recurring thoughts, images, or impulses that feel intrusive and cause you distress?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you find yourself performing repetitive behaviors (e.g., hand-washing, checking things, counting) to reduce anxiety?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you ever feel the need to check things multiple times to make sure they are done correctly (e.g., locks, appliances, doors)?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you feel compelled to arrange objects in a particular way to feel comfortable or prevent bad things from happening?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you experience distress if you are unable to complete a specific routine or ritual?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you experience strong fears of contamination, leading you to avoid touching certain objects or excessive cleaning?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you worry excessively about things being symmetrical, exact, or 'just right'?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you feel the need to mentally review conversations, actions, or situations repeatedly to ensure you didn't make a mistake?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you experience distressing or unwanted thoughts about harming yourself or others, even though you don't want to act on them?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do your obsessive thoughts or compulsive behaviors interfere with your daily life, work, relationships, or responsibilities?",
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
        Uri.parse('http://192.168.212.120:5000/api/ocd/analyze-ocd'),
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
        throw Exception('Failed to analyze OCD responses.');
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
        title: const Text('OCD Self-Assessment'),
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
