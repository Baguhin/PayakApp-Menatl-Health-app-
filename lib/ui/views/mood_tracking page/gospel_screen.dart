import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GospelScreen extends StatefulWidget {
  final String moodType;

  const GospelScreen({Key? key, required this.moodType}) : super(key: key);

  @override
  _GospelScreenState createState() => _GospelScreenState();
}

class _GospelScreenState extends State<GospelScreen> {
  String? gospelVerse;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchGospelVerse();
  }

  // Fetch gospel verse from backend
  Future<void> fetchGospelVerse() async {
    final String apiUrl =
        "https://legit-backend-iqvk.onrender.com/api/gospel?mood=${widget.moodType}";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          gospelVerse = data['verse'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error fetching gospel verse: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.moodType} Mood Verse'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 8,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images21/calm4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay for better readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Scrollable Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : hasError
                      ? const Text(
                          "Failed to load verse. Please try again.",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                          textAlign: TextAlign.center,
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.moodType,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.tealAccent,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black45,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    gospelVerse ?? "No verse available.",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 8.0,
                                          color: Colors.black38,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Action for sharing the verse
                                },
                                icon: const Icon(Icons.share,
                                    color: Colors.white),
                                label: const Text('Share This Verse'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text('Back to Moods'),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
