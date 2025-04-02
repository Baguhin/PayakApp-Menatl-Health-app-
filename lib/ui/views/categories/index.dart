import 'package:flutter/material.dart';
import 'models.dart';
import 'musicplayer.dart';
import 'services/music_services.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late Future<List<Music>> musicList;

  @override
  void initState() {
    super.initState();
    musicList = MusicService().fetchMeditationMusic('calming sounds');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Music'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: FutureBuilder<List<Music>>(
        future: musicList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No music found'));
          } else {
            final music = snapshot.data!;

            return ListView.builder(
              itemCount: music.length,
              itemBuilder: (context, index) {
                final musicItem = music[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () => _navigateToMusicPlayer(context, musicItem),
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          // Music Image (you can replace with an actual image URL)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images21/music.png'), // Add your image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Music Title and Description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  musicItem.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  musicItem.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Play Icon Button
                          const Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Navigate to the MusicPlayerScreen to play the music
  void _navigateToMusicPlayer(BuildContext context, Music musicItem) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return MusicPlayerScreen(music: musicItem, preference: '');
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
