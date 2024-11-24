// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String title;

  const VideoPlayerPage({Key? key, required this.videoId, required this.title})
      : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Video Player',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video Player
            Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  onReady: () {
                    // You can perform actions once the player is ready
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Video Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Video Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'A soothing sleep stories to help you relax and sleep peacefully.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // Rewind functionality
                    _controller.seekTo(Duration(
                        seconds: (_controller.value.position.inSeconds - 10).clamp(
                            0,
                            _controller.value.position
                                .inSeconds))); // Use position instead of duration
                  },
                  icon: const Icon(Icons.replay_10),
                  color: Colors.deepPurple,
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    // Play/Pause functionality
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  color: Colors.deepPurple,
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    // Forward functionality
                    _controller.seekTo(Duration(
                        seconds: (_controller.value.position.inSeconds + 10).clamp(
                            0,
                            _controller.value.position
                                .inSeconds))); // Use position instead of duration
                  },
                  icon: const Icon(Icons.forward_10),
                  color: Colors.deepPurple,
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 20), // Space before the next section
          ],
        ),
      ),
    );
  }
}
