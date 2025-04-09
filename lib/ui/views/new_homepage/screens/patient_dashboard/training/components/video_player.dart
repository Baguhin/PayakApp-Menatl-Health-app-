import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;

  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    required this.title,
    String? initialTitle, // Made optional to match with your implementation
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isLoading = true;
  bool _isFullScreen = false;
  bool _isPlaying = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    print('Initializing player with videoId: ${widget.videoId}'); // Debug log

    // Initialize the controller with proper configuration
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        showLiveFullscreenButton: true,
        forceHD: true, // Force HD playback for better quality
      ),
    );

    // Add listeners to track player state
    _controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    // Check for errors
    if (_controller.value.errorCode != 0) {
      setState(() {
        _errorMessage = 'Error code: ${_controller.value.errorCode}';
        _isLoading = false;
      });
    }

    // Update loading state
    if (_controller.value.isReady && _isLoading) {
      setState(() {
        _isLoading = false;
      });
    }

    // Update playing state
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: _errorMessage.isNotEmpty
          ? _buildErrorWidget()
          : Column(
              children: [
                YoutubePlayerBuilder(
                  onExitFullScreen: () {
                    setState(() {
                      _isFullScreen = false;
                    });
                  },
                  onEnterFullScreen: () {
                    setState(() {
                      _isFullScreen = true;
                    });
                  },
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    onReady: () {
                      setState(() {
                        _isLoading = false;
                      });
                      print('YouTube Player Ready'); // Debug log
                    },
                    topActions: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          // Show quality options
                          _controller.pause();
                          _showQualityOptions();
                        },
                      ),
                    ],
                    bottomActions: const [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                        colors: ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent,
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      RemainingDuration(),
                      PlaybackSpeedButton(),
                      FullScreenButton(),
                    ],
                  ),
                  builder: (context, player) {
                    return Column(
                      children: [
                        // Player
                        player,

                        // Video info
                        if (!_isFullScreen)
                          Expanded(
                            child: _isLoading
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.red),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Loading video...',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  )
                                : _buildVideoDetails(),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                setState(() {
                  _errorMessage = '';
                  _isLoading = true;
                });
                _controller.load(widget.videoId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Video Quality',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildQualityOption('Auto'),
              _buildQualityOption('1080p HD'),
              _buildQualityOption('720p HD'),
              _buildQualityOption('480p'),
              _buildQualityOption('360p'),
              _buildQualityOption('240p'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _controller.play();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQualityOption(String quality) {
    return ListTile(
      title: Text(
        quality,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      onTap: () {
        Navigator.pop(context);
        _controller.play();
        // Note: YouTube Flutter plugin doesn't directly support quality selection
        // This would be just a UI demonstration
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Switched to $quality')),
        );
      },
    );
  }

  Widget _buildVideoDetails() {
    return Container(
      color: Colors.black,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Video title with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Video metadata with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: const Row(
              children: [
                Icon(Icons.visibility_outlined,
                    color: Colors.white60, size: 16),
                SizedBox(width: 4),
                Text(
                  "Views: N/A",
                  style: TextStyle(color: Colors.white60),
                ),
                SizedBox(width: 16),
                Icon(Icons.calendar_today_outlined,
                    color: Colors.white60, size: 16),
                SizedBox(width: 4),
                Text(
                  "Published: N/A",
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Video controls with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 700),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(Icons.thumb_up_outlined, 'Like'),
                  _buildControlButton(Icons.thumb_down_outlined, 'Dislike'),
                  _buildControlButton(Icons.share_outlined, 'Share'),
                  _buildControlButton(Icons.save_alt_outlined, 'Save'),
                  _buildControlButton(Icons.comment_outlined, 'Comment'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description section with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * 20),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No description available for this video.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label action')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
