// sleepstories.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'video_player_page.dart'; // Import the video player page

class SleepStoriesPage extends StatefulWidget {
  const SleepStoriesPage({Key? key}) : super(key: key);

  @override
  _SleepStoriesPageState createState() => _SleepStoriesPageState();
}

class _SleepStoriesPageState extends State<SleepStoriesPage> {
  // List of YouTube video IDs for goodnight stories
  final List<Map<String, String>> _sleepStories = [
    {
      'title': 'Goodnight Story - One Man And A Dog',
      'videoId': 'ILYGKuZlXvg' // Example video ID
    },
    {
      'title': 'Soothing Bedtime Story - Lighthouse Keeper',
      'videoId': '8V1LD2hgNug' // Replace with actual YouTube video ID
    },
    {
      'title':
          'Enchanted Sleep Stories - The Gentle Giant & And His Secret World',
      'videoId': 'IgcbbZt36YQ' // Replace with actual YouTube video ID
    },
    {
      'title':
          'BedTime Stories With Rain - The Astronomer | Bedtime Story for Grown Ups',
      'videoId': '_q5L0JLi0zo' // Replace with actual YouTube video ID
    },
    {
      'title':
          'A Snowy Night in Paris - A Soothing Sleep Story to Calm Mind and Body',
      'videoId': 'xUAswZ5OQlw' // Replace with actual YouTube video ID
    },
    // Add more stories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goodnight Stories'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // List of stories
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _sleepStories.length,
              itemBuilder: (context, index) {
                final story = _sleepStories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading:
                        const Icon(Icons.bedtime, color: Colors.deepPurple),
                    title: Text(
                      story['title']!,
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // Navigate to the video player page with the selected story's video ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(
                            videoId: story['videoId']!,
                            title: '',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
