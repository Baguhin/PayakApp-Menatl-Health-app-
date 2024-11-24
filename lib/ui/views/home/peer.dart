import 'package:flutter/material.dart';

class PeerGroupView extends StatelessWidget {
  const PeerGroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme; // Get ColorScheme

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: color.onPrimary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Peer Group Events',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEventCard(
              context,
              'Mental Health Workshop',
              'A workshop on mental health awareness and support.',
              Icons.event,
              'assets/images/workshop.png', // Replace with appropriate image
              () {
                // Handle navigation or event action
              },
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              context,
              'Seminar on Coping Mechanisms',
              'Learn about effective coping strategies for stress.',
              Icons.school,
              'assets/img/r1.png', // Replace with appropriate image
              () {
                // Handle navigation or event action
              },
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              context,
              'Community Meetup',
              'Join a supportive community discussion on mental health.',
              Icons.people,
              'assets/img/r2.png', // Replace with appropriate image
              () {
                // Handle navigation or event action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String assetName,
    VoidCallback onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      shadowColor: Colors.black45,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                assetName,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
