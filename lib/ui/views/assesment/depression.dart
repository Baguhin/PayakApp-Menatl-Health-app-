import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../survey_results/assestment.dart';

class DepressionTestScreen extends StatefulWidget {
  const DepressionTestScreen({super.key});

  @override
  _DepressionTestScreenState createState() => _DepressionTestScreenState();
}

class _DepressionTestScreenState extends State<DepressionTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          "Over the past two weeks, how often have you felt little interest or pleasure in doing things?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Over the past two weeks, how often have you been feeling down, depressed, or hopeless?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you experienced trouble falling or staying asleep, or sleeping too much?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you often feel tired or have little energy, even after resting?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you experienced a significant change in appetite, either eating too much or too little?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you often feel bad about yourself, or feel like you are a failure or have let yourself or others down?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you have trouble concentrating on things such as reading, watching TV, or working?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you noticed that you are moving or speaking more slowly than usual, or feeling restless and fidgety?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Have you had thoughts that you would be better off dead, or thoughts of hurting yourself?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do your symptoms make it difficult for you to work, take care of daily responsibilities, or interact with others?",
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
            'http://192.168.212.120:5000/api/depression/analyze-depression'),
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
        throw Exception('Failed to analyze Depression responses.');
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
        title: const Text('Depression Self-Assessment'),
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
