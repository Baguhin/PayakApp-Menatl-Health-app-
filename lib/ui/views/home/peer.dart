import 'package:flutter/material.dart';
import '../../../who/newspage.dart';
import '../seminar_coping_worksop/get_all_seminar.dart';
import 'challengesUI.dart';

class PeerGroupView extends StatelessWidget {
  const PeerGroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme; // Get theme colors

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: color.onPrimary,
          onPressed: () => Navigator.of(context).pop(),
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
              'Comunity Challenges and wellness Goals',
              'A workshop on mental health awareness and support.',
              Icons.event,
              'assets/images21/workshop.png',
              () {
                // Navigate to NewsFeedPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChallengesScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              context,
              'Seminar on Coping Mechanisms',
              'Learn about effective coping strategies for stress.',
              Icons.school,
              'assets/img/r1.png',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SeminarFeedPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              context,
              'Support Group Meetup',
              'Join a supportive community discussion on mental health.',
              Icons.people,
              'assets/img/r2.png',
              () {},
            ),
            const SizedBox(height: 16),
            _buildEventCard(
              context,
              'Latest Health News',
              'Stay updated with the latest health news worldwide.',
              Icons.article,
              'assets/icons/news.png',
              () {
                // Navigate to NewsFeedPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsFeedPage()),
                );
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
      elevation: 6,
      shadowColor: Colors.black38,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  assetName,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                ),
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
