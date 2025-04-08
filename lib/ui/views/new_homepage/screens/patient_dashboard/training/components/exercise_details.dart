import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/course.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Course course;

  const ExerciseDetailsScreen({Key? key, required this.course})
      : super(key: key);

  @override
  _ExerciseDetailsScreenState createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> exercises = [];
  List<Map<String, dynamic>> videoList = [];
  bool isLoading = true;
  bool isVideoLoading = false;
  late TabController _tabController;
  int _selectedExerciseIndex = -1;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  YoutubePlayerController? _controller;

  get encodedCourseName => null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchExercises();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller?.dispose();
    super.dispose();
  }

// Function to fetch exercises and videos
  Future<void> fetchExercises() async {
    final encodedCourseName = Uri.encodeComponent(widget.course.name);
    final url =
        "https://legit-backend-iqvk.onrender.com/api/exercises/category/$encodedCourseName";

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          exercises = List<Map<String, dynamic>>.from(
              data['exercises'].map((exercise) => {
                    "id": exercise['id'] ?? 0,
                    "name": exercise['title'] ?? "Unknown Exercise",
                    "description":
                        exercise['description'] ?? "No description available",
                    "difficulty": exercise['difficulty'] ?? "Beginner",
                    "duration": exercise['duration'] ?? "5 min",
                  }));
          videoList = List<Map<String, dynamic>>.from(
              data['youtubeVideos'].map((video) => {
                    "videoId": video['videoId'] ?? "",
                    "title": video['title'] ?? "No Title",
                    "thumbnail":
                        video['thumbnail'] ?? "https://via.placeholder.com/150",
                    "description":
                        video['description'] ?? "No description available",
                    "duration": video['duration'] ?? "00:00",
                  }));
          isLoading = false;

          if (videoList.isNotEmpty) {
            // Automatically switch to the videos tab
            _tabController.animateTo(1);
          } else {
            _showErrorSnackBar("No videos available for this exercise.");
          }
        });
      } else {
        setState(() {
          isLoading = false;
          _showErrorSnackBar("Failed to load exercises. Please try again.");
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _showErrorSnackBar("Network error. Please check your connection.");
      });
    }
  }

  Future<void> fetchVideos(String courseName, int index) async {
    final encodedCourseName = Uri.encodeComponent(courseName);
    final url =
        "https://legit-backend-iqvk.onrender.com/api/exercises/category/$encodedCourseName";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          videoList = List<Map<String, dynamic>>.from(
              data['youtubeVideos'].map((video) => {
                    "videoId": video['videoId'] ?? "",
                    "title": video['title'] ?? "No Title",
                    "thumbnail":
                        video['thumbnail'] ?? "https://via.placeholder.com/150",
                    "description":
                        video['description'] ?? "No description available",
                    "duration": video['duration'] ?? "00:00",
                  }));
          isVideoLoading = false;

          if (videoList.isNotEmpty) {
            _tabController.animateTo(1);
          } else {
            _showErrorSnackBar("No videos available for this exercise.");
          }
        });
      } else {
        setState(() {
          isVideoLoading = false;
          _showErrorSnackBar("Failed to load videos. Please try again.");
        });
      }
    } catch (e) {
      setState(() {
        isVideoLoading = false;
        _showErrorSnackBar("Network error. Please check your connection.");
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchExercises();
              setState(() {
                videoList = [];
                _selectedExerciseIndex = -1;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Exercises', icon: Icon(Icons.fitness_center)),
            Tab(text: 'Videos', icon: Icon(Icons.play_circle_filled)),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: fetchExercises,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Exercises Tab
              isLoading
                  ? _buildShimmerEffect()
                  : exercises.isEmpty
                      ? _buildEmptyState(
                          "No exercises available for this course.",
                          Icons.fitness_center)
                      : _buildExercisesGridView(),

              // Videos Tab
              isVideoLoading
                  ? _buildLoadingState("Loading videos...")
                  : videoList.isEmpty
                      ? _buildEmptyState(
                          "Select an exercise to view videos.", Icons.videocam)
                      : _buildVideosListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExercisesGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return _buildExerciseCard(index);
      },
    );
  }

  Widget _buildExerciseCard(int index) {
    final isSelected = index == _selectedExerciseIndex;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? const BorderSide(color: Colors.redAccent, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            String videoId = exercises[index]['id'].toString();
            if (videoId == "0") {
              _showErrorSnackBar("This exercise has no videos available.");
              return;
            }
            fetchVideos(videoId, index);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise icon with difficulty color
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(exercises[index]['difficulty'])
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getExerciseIcon(exercises[index]['name']),
                    color: _getDifficultyColor(exercises[index]['difficulty']),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                // Exercise name
                Text(
                  exercises[index]['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Duration
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      exercises[index]['duration'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Difficulty
                Row(
                  children: [
                    Icon(Icons.fitness_center,
                        size: 14,
                        color: _getDifficultyColor(
                            exercises[index]['difficulty'])),
                    const SizedBox(width: 4),
                    Text(
                      exercises[index]['difficulty'],
                      style: TextStyle(
                        color:
                            _getDifficultyColor(exercises[index]['difficulty']),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Videos available indicator
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_filled,
                            size: 14, color: Colors.redAccent),
                        SizedBox(width: 4),
                        Text(
                          'Videos',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideosListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(index);
      },
    );
  }

  Widget _buildVideoCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoId: videoList[index]['videoId'],
                title: videoList[index]['title'],
                initialTitle: _selectedExerciseIndex >= 0
                    ? exercises[_selectedExerciseIndex]['name']
                    : widget.course.name,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button overlay
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    videoList[index]['thumbnail'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                // Duration indicator
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      videoList[index]['duration'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Play button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    videoList[index]['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    videoList[index]['description'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Exercise name indicator
                  if (_selectedExerciseIndex >= 0)
                    Row(
                      children: [
                        Icon(Icons.fitness_center,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'From: ${exercises[_selectedExerciseIndex]['name']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Loading and empty states
  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (message.contains("Select an exercise"))
            ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(0);
              },
              icon: const Icon(Icons.fitness_center),
              label: const Text("Go to Exercises"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getExerciseIcon(String exerciseName) {
    final name = exerciseName.toLowerCase();
    if (name.contains('cardio') || name.contains('run')) {
      return Icons.directions_run;
    } else if (name.contains('stretch') || name.contains('yoga')) {
      return Icons.self_improvement;
    } else if (name.contains('weight') || name.contains('strength')) {
      return Icons.fitness_center;
    } else if (name.contains('balance') || name.contains('core')) {
      return Icons.accessibility_new;
    } else {
      return Icons.sports_gymnastics;
    }
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String initialTitle;

  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    required this.title,
    required this.initialTitle,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

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
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
          print('Player is ready.');
        },
      ),
    );
  }
}
