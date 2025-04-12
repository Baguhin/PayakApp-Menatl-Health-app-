import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animations/animations.dart'; // Import for smooth transition animations

// Import the modified home page
import 'package:tangullo/ui/views/home/sleep/live_detection/livedetection.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for smooth page transition
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation, // Apply fade-in animation
      child: Scaffold(
        backgroundColor: Colors.white, // Clean background
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Emotion Detection',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // Lottie animation
                Lottie.asset(
                  'assets/videos/animation.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                  frameRate: FrameRate.max, // Smooth animation playback
                ),
                const SizedBox(height: 20),
                const Text(
                  'AI-Powered Emotion Detection',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upload a photo or take a new picture to analyze facial expressions using AI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                // Improved button with smooth transition animation
                OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  transitionDuration: const Duration(milliseconds: 600),
                  openBuilder: (context, _) => const Home(),
                  closedElevation: 8,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  closedColor: Colors.deepPurpleAccent,
                  closedBuilder: (context, openContainer) => InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: openContainer,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                      child: Column(
                        children: [
                          Icon(Icons.add_photo_alternate,
                              color: Colors.white, size: 60),
                          SizedBox(height: 12),
                          Text(
                            'Get Started',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  'Powered by AI & Deep CNN Algorithm',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
