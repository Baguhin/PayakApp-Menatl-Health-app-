import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tangullo/ui/views/new_homepage/screens/patient_dashboard/training/components/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../models/course.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Course course;

  const ExerciseDetailsScreen({Key? key, required this.course})
      : super(key: key);

  @override
  _ExerciseDetailsScreenState createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  List<Map<String, dynamic>> exercises = [];
  List<Map<String, dynamic>> videoList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    final encodedCourseName = Uri.encodeComponent(widget.course.name);
    final url =
        "https://legit-backend-iqvk.onrender.com/api/exercises/search/$encodedCourseName";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          exercises = data
              .map((exercise) => {
                    "id": exercise['id'] ?? 0,
                    "name": exercise['title'] ?? "Unknown Exercise"
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchVideos(String videoId) async {
    if (videoId.isEmpty) {
      return;
    }

    setState(() => isLoading = true);
    final url =
        "https://legit-backend-iqvk.onrender.com/api/exercises/$videoId/videos";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          videoList = data
              .map((video) => {
                    "videoId": video['videoId'] ?? "",
                    "title": video['title'] ?? "No Title",
                    "thumbnail":
                        video['thumbnail'] ?? "https://via.placeholder.com/150"
                  })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? _buildShimmerEffect() // Display shimmer effect while loading
          : exercises.isEmpty
              ? const Center(child: Text("No exercises available."))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          return _buildExerciseListItem(index);
                        },
                      ),
                    ),
                    if (videoList.isEmpty)
                      const Center(
                        child: Text("Select an exercise to load videos."),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: videoList.length,
                          itemBuilder: (context, index) {
                            return _buildVideoCard(index);
                          },
                        ),
                      ),
                  ],
                ),
    );
  }

  // Shimmer effect for loading
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Show 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  // Exercise List Item Design Enhancement
  Widget _buildExerciseListItem(int index) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          title: Text(
            exercises[index]['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          trailing:
              const Icon(Icons.play_circle_fill, color: Colors.green, size: 30),
          onTap: () {
            String videoId = exercises[index]['id'].toString();
            if (videoId == "0") {
              return;
            }
            fetchVideos(videoId);
          },
        ),
      ),
    );
  }

  // Animated video card with a sleek transition
  Widget _buildVideoCard(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoId: videoList[index]['videoId'],
              title: videoList[index]['title'],
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                videoList[index]['thumbnail'],
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network("https://via.placeholder.com/150");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                videoList[index]['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
