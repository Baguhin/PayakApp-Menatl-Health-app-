import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;

  const YouTubePlayerScreen({
    super.key,
    required this.videoId,
    required this.title,
    required this.description,
  });

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Video Player'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFullScreen = !isFullScreen;
              });
              if (isFullScreen) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: []);
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft
                ]);
              } else {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(controller: _controller),
              builder: (context, player) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Video Information
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Title Text
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(2, 2))
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // Description Text
                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // Video player with rounded corners
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: player,
                    ),
                    const SizedBox(height: 10),
                    // Controls (Play/Pause, Seek bar, Mute/Unmute)
                    _buildControls(),
                  ],
                );
              },
            ),
          ),
          // Semi-transparent background overlay with gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Controls: Play/Pause, Seek Bar, Mute/Unmute
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Play/Pause button
          IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            },
          ),
          const SizedBox(height: 20),
          // Seek bar
          Slider(
            value: _controller.value.position.inSeconds.toDouble(),
            min: 0,
            max: _controller.metadata.duration.inSeconds
                .toDouble(), // Set max to the video's total duration
            onChanged: (double value) {
              _controller.seekTo(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.white,
            inactiveColor: Colors.white54,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
