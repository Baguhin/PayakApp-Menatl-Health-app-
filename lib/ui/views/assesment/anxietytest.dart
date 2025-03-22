import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../survey_results/adhd_result_screen.dart';

class AnxietyTestScreen extends StatefulWidget {
  const AnxietyTestScreen({super.key});

  @override
  _AnxietyTestScreenState createState() => _AnxietyTestScreenState();
}

class _AnxietyTestScreenState extends State<AnxietyTestScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          "Do you often feel excessively worried or anxious about multiple aspects of your life (e.g., work, school, relationships)?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you frequently experience physical symptoms such as sweating, trembling, or a racing heart without an obvious cause?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you find it difficult to relax, even when you have free time?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you often have trouble falling asleep or staying asleep due to anxious thoughts?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you feel a sense of impending danger, panic, or doom without any apparent reason?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you frequently avoid social situations or interactions due to feelings of anxiety or nervousness?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you find yourself overthinking and analyzing situations excessively, even small decisions?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you experience sudden episodes of intense fear or panic (panic attacks), sometimes without a clear trigger?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you frequently experience muscle tension, headaches, or stomach discomfort due to stress or anxiety?",
      'options': ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
    },
    {
      'question':
          "Do you struggle to concentrate or feel like your mind goes blank when you're feeling anxious?",
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
        Uri.parse('http://192.168.212.120:5000/api/anxiety/analyze-anxiety'),
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
        throw Exception('Failed to analyze Anxiety responses.');
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
        title: const Text('Anxiety Self-Assessment'),
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
