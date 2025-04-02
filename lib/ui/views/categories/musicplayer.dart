import 'package:flutter/material.dart';
import 'models.dart';

import 'music_player/vedio.dart'; // Assuming this is where YouTubePlayerScreen is
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MusicPlayerScreen extends StatelessWidget {
  final String preference;
  final Music music;

  const MusicPlayerScreen(
      {super.key, required this.preference, required this.music});
  void _openYouTubePlayer(BuildContext context, String youtubeUrl) {
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YouTubePlayerScreen(
            videoId: videoId,
            title: 'Video Title Here', // Provide the correct title here
            description:
                'Video description here', // Provide the correct description here
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
        toolbarHeight: 80, // To make the app bar taller for a more refined look
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Music Image
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image:
                      AssetImage('assets/images21/music.png'), // Example image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Displaying the music title and description
            Text(
              music.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              music.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Play on YouTube Button
            ElevatedButton(
              onPressed: () => _openYouTubePlayer(context, music.youtubeLink),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // YouTube color
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 5, // Adds a shadow effect for a modern look
              ),
              child: const Text('Play on Video'),
            ),
            const SizedBox(height: 20),

            // Play on Spotify Button
            ElevatedButton(
              onPressed: () {
                // Show the "In Development" message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('In Development comming soon!'),
                    duration: Duration(seconds: 2), // Duration of the Snackbar
                  ),
                );

                // Optional: You can also add your actual navigation logic or other actions here
                // _openSpotifyPlayer(context, music.spotifyLink);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Spotify color
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 5, // Adds a shadow effect
              ),
              child: const Text('Play on Music'),
            )
          ],
        ),
      ),
    );
  }
}
