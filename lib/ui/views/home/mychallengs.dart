import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyChallengesScreen extends StatefulWidget {
  const MyChallengesScreen({super.key});

  @override
  _MyChallengesScreenState createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> {
  List<Map<String, dynamic>> joinedChallenges = [];

  @override
  void initState() {
    super.initState();
    loadJoinedChallenges();
  }

  Future<void> loadJoinedChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedChallenges =
        prefs.getStringList('joinedChallenges') ?? [];
    setState(() {
      joinedChallenges = storedChallenges
          .map((id) => {'id': int.parse(id), 'progress': 0})
          .toList();
    });
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.212.120:5000/api/challenges/progress?user_id=1'));
      if (response.statusCode == 200) {
        Map<String, dynamic> progressData = json.decode(response.body);
        setState(() {
          joinedChallenges = joinedChallenges.map((challenge) {
            int challengeId = challenge['id'];
            return {
              'id': challengeId,
              'progress': progressData[challengeId.toString()] ?? 0,
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Failed to fetch progress: $e");
    }
  }

  Future<void> updateProgress(int challengeId, int progress) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.212.120:5000/api/challenges/progress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'user_id': 1, 'challenge_id': challengeId, 'progress': progress}),
      );
      if (response.statusCode == 200) {
        setState(() {
          for (var challenge in joinedChallenges) {
            if (challenge['id'] == challengeId) {
              challenge['progress'] = progress;
            }
          }
        });
      }
    } catch (e) {
      print("Failed to update progress: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Challenges',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: joinedChallenges.isEmpty
          ? const Center(
              child: Text("No joined challenges yet!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: joinedChallenges.length,
              itemBuilder: (context, index) {
                final challenge = joinedChallenges[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Challenge #${challenge['id']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Stack(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                            ),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width *
                                  (challenge['progress'] / 100),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.greenAccent
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("Progress: ${challenge['progress']}%",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int step in [25, 50, 75, 100])
                              ElevatedButton(
                                onPressed: () =>
                                    updateProgress(challenge['id'], step),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("$step%",
                                    style: const TextStyle(fontSize: 16)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
