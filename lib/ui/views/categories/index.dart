import 'package:flutter/material.dart';

import 'RelaxationPlayerPage.dart';

class RelaxPage extends StatelessWidget {
  const RelaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _RelaxPagePage();
  }
}

class _RelaxPagePage extends StatefulWidget {
  @override
  _SleepStoriesPageState createState() => _SleepStoriesPageState();
}

class _SleepStoriesPageState extends State<_RelaxPagePage> {
  final List<Map<String, String>> _sleepStories = [
    {
      'title':
          'Alpha Waves Heal The Whole Body and Spirit, Emotional, Physical, Mental & Spiritual Healing',
      'videoId': 'u3papaX85MA',
    },
    {
      'title':
          'Relaxing Music for Meditation. Calming Music for Stress Relief, Yoga',
      'videoId': '29IY8aiOnyE',
    },
    {
      'title':
          'Ultra Healing Relaxing Music for Nervous Disorders, Depression. Restores Mental Health',
      'videoId': 'Y9iM7HF3nDw',
    },
    {
      'title':
          'Relaxing music Relieves stress, Anxiety and Depression 🌿 Heals the Mind, body and Soul - Deep Sleep',
      'videoId': 'I3OJUwILelU',
    },
    {
      'title':
          'Beautiful Relaxing Music - Healing Music For Health And Calming The Nervous System, Deep Relaxation',
      'videoId': 'VbT2wQq5jQY',
    },
    {
      'title':
          'Tibetan Flute Healing Stops Overthinking, Eliminates Stress, Anxiety and Calms the Mind',
      'videoId': 'Wi_dQEtX4AQ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relaxation'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade100,
              Colors.deepPurple.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _sleepStories.length,
                itemBuilder: (context, index) {
                  final story = _sleepStories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.spa,
                          color: Colors.deepPurple, size: 30), // Updated icon
                      title: Text(
                        story['title']!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: const Text(
                        'Tap to play',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RelaxationPlayerPage(
                              videoId: story['videoId']!,
                              title: story['title']!,
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
      ),
    );
  }
}
