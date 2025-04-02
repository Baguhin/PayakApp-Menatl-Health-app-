import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<Map<String, dynamic>> challenges = [];

  @override
  void initState() {
    super.initState();
    fetchChallenges();
  }

  Future<void> fetchChallenges() async {
    try {
      final response = await http.get(Uri.parse(
          'https://legit-backend-iqvk.onrender.com/api/music/meditation-music/api/challenges'));
      if (response.statusCode == 200) {
        setState(() {
          challenges =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      }
    } catch (e) {
      print("Failed to fetch challenges: $e");
    }
  }

  Future<void> joinChallenge(int challengeId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://legit-backend-iqvk.onrender.com/api/music/meditation-music/api/challenges/join'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': 1, 'challenge_id': challengeId}),
      );
      if (response.statusCode == 200) {
        saveJoinedChallenge(challengeId);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Joined challenge!')));
      }
    } catch (e) {
      print("Failed to join challenge: $e");
    }
  }

  Future<void> updateProgress(int challengeId, double progress) async {
    try {
      await http.put(
        Uri.parse(
            'https://legit-backend-iqvk.onrender.com/api/music/meditation-music/api/challenges/progress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'user_id': 1, 'challenge_id': challengeId, 'progress': progress}),
      );
      fetchChallenges();
    } catch (e) {
      print("Failed to update progress: $e");
    }
  }

  void showChallengeDetails(Map<String, dynamic> challenge) {
    List<String> activities =
        List<String>.from(json.decode(challenge['activities'] ?? "[]"));
    List<bool> completed = List.generate(activities.length, (index) => false);
    TextEditingController journalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(challenge['title'] ?? "No Title"),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Activities:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...List.generate(
                    activities.length,
                    (index) => CheckboxListTile(
                          title: Text(activities[index]),
                          value: completed[index],
                          onChanged: (value) {
                            setDialogState(() {
                              completed[index] = value ?? false;
                            });
                          },
                        )),
                const SizedBox(height: 10),
                const Text("Journal:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                    controller: journalController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder())),
                const SizedBox(height: 10),
                Text("Progress: ${(challenge['progress'] ?? 0).toString()}%"),
                Slider(
                  value: (challenge['progress'] ?? 0).toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: "${(challenge['progress'] ?? 0).toString()}%",
                  onChanged: (value) {
                    setDialogState(() {
                      challenge['progress'] = value.toInt();
                    });
                  },
                  onChangeEnd: (value) =>
                      updateProgress(challenge['id'], value),
                )
              ],
            );
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Challenges',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: challenges.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(challenge['title'] ?? "No Title",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                        const SizedBox(height: 5),
                        Text(challenge['description'] ?? "No Description",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700])),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                            value: (challenge['progress'] ?? 0) / 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () => joinChallenge(challenge['id']),
                                child: const Text('Join')),
                            ElevatedButton(
                                onPressed: () =>
                                    showChallengeDetails(challenge),
                                child: const Text('Details')),
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

  void saveJoinedChallenge(int challengeId) {}
}
