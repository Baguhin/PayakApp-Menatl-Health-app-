import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SeminarFeedPage extends StatefulWidget {
  const SeminarFeedPage({super.key});

  @override
  _SeminarFeedPageState createState() => _SeminarFeedPageState();
}

class _SeminarFeedPageState extends State<SeminarFeedPage> {
  List<dynamic> seminars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSeminars();
  }

  Future<void> fetchSeminars() async {
    try {
      final response = await http.get(
          Uri.parse('https://legit-backend-iqvk.onrender.com/api/seminars'));
      if (response.statusCode == 200) {
        setState(() {
          seminars = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load seminars')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seminars'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchSeminars,
              child: seminars.isEmpty
                  ? const Center(
                      child: Text('No seminars available'),
                    )
                  : ListView.builder(
                      itemCount: seminars.length,
                      itemBuilder: (context, index) {
                        final seminar = seminars[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                color: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  seminar['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      seminar['description'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Text(seminar['date']),
                                        const SizedBox(width: 16),
                                        const Icon(Icons.access_time, size: 16),
                                        const SizedBox(width: 8),
                                        Text(seminar['time']),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 16),
                                        const SizedBox(width: 8),
                                        Text(seminar['instructor']),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const SizedBox(width: 8),
                                        Text(seminar['location']),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${seminar['current_participants']}/${seminar['capacity']} participants',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final response = await http.post(
                                                Uri.parse(
                                                    'https://legit-backend-iqvk.onrender.com/api/seminars/${seminar['id']}/register'),
                                                body: {
                                                  'user_id': '1'
                                                }, // Replace with actual user ID
                                              );

                                              if (response.statusCode == 200) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Registration successful!')),
                                                );
                                                fetchSeminars(); // Refresh the list
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Registration failed')),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Error registering for seminar')),
                                              );
                                            }
                                          },
                                          child: const Text('Register'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
