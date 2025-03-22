import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../survey_results/assestment.dart';

class EatingDisorderTestScreen extends StatefulWidget {
  const EatingDisorderTestScreen({super.key});

  @override
  _EatingTestScreenState createState() => _EatingTestScreenState();
}

class _EatingTestScreenState extends State<EatingDisorderTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          "Do you often worry about your weight or body shape influencing how you feel about yourself?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you recently restricted the amount of food you eat to control your weight (e.g., skipping meals, fasting)?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you ever feel like you lose control over how much you eat during a meal or snack?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you engaged in behaviors to compensate for eating (e.g., vomiting, excessive exercise, or using laxatives)?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you avoid eating with others due to concerns about food, weight, or body image?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you experienced strong guilt or shame after eating, even if it was a normal amount of food?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you engage in secretive eating, such as hiding food or eating alone to avoid judgment?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you felt that food, weight, or dieting thoughts consume a significant amount of your daily thoughts?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Has your weight fluctuated significantly in a short period due to eating habits or dieting efforts?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have your eating behaviors negatively affected your physical health, social life, or daily responsibilities?",
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
        Uri.parse(
            'http://192.168.212.120:5000/api/eating-disorder/analyze-eating-disorder'),
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
        throw Exception('Failed to analyze Eating Disorder responses.');
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
        title: const Text('Eating Disorder Self-Assessment'),
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
