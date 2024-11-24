// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:tangullo/ui/views/home/assessment.dart';
import 'package:tangullo/ui/views/home/helpline.dart';
import 'package:tangullo/ui/views/home/peer.dart';
import 'package:tangullo/ui/views/home/smart_stress.dart';
import 'package:tangullo/ui/views/meditation/meditation_view.dart';
import 'package:tangullo/ui/views/mood_tracking%20page/gospel_screen.dart';

import 'package:tangullo/widgets/task.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mood_tracking page/allreportview.dart';

import 'userfeedback.dart';

class Home extends StatelessWidget {
  final String userName;

  const Home({super.key, required this.userName});

  static const List<String> quotes = [
    "Believe you can and you're halfway there.",
    "The only way to do great work is to love what you do.",
    "You are never too old to set another goal or to dream a new dream.",
    "Success is not how high you have climbed, but how you make a positive difference to the world.",
    "The best way to predict the future is to create it.",
    "Your limitation—it's only your imagination.",
    "Push yourself, because no one else is going to do it for you.",
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.primary,
        title: const Text('Home'),
      ),
      drawer: _buildDrawer(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          _buildWelcomeText(color),
          const SizedBox(height: 10),
          _buildInspiringQuote(color),
          const SizedBox(height: 20),
          _buildFeelingQuestion(color),
          const SizedBox(height: 10),
          _buildMoodSelection(context, color),
          const SizedBox(height: 30),
          _buildMoodReportsButton(context, color),
          const SizedBox(height: 30),
          _buildTodayTaskTitle(color),
          const SizedBox(height: 20),
          _buildPeerGroupTask(
              color, context), // Pass both color and context here
          const SizedBox(height: 30),
          _buildMeditationTask(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/johnchris.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hello, $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
              context, Icons.assessment, 'Assessment', const Assessment()),
          _buildDrawerItem(context, Icons.call, 'Helpline', const Helpline()),
          _buildDrawerItem(context, Icons.batch_prediction, 'Smart Prediction',
              const SmartStress()),
          _buildDrawerItem(
              context, Icons.feedback, 'User Feedback', const FeedbackPage()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  Widget _buildWelcomeText(ColorScheme color) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Welcome back,',
            style: GoogleFonts.alegreya(
              color: color.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: ' $userName!',
            style: GoogleFonts.alegreya(
              color: color.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspiringQuote(ColorScheme color) {
    final randomQuote = quotes[Random().nextInt(quotes.length)];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '"$randomQuote"',
        style: TextStyle(
          color: color.onSurface,
          fontSize: 18,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFeelingQuestion(ColorScheme color) {
    return Text(
      'How are you feeling today?',
      style: TextStyle(
        color: color.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMoodSelection(BuildContext context, ColorScheme color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20), // Add vertical padding
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMoodFace(
              context,
              color,
              'Joy',
              'assets/images/happy.png',
              const Color.fromARGB(255, 255, 193, 7), // Yellow for Joy
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Fear',
              'assets/images/calm.png',
              const Color.fromARGB(255, 63, 81, 181), // Blue for Fear
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Disgust',
              'assets/images/relax.png',
              const Color.fromARGB(255, 76, 175, 80), // Green for Disgust
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Anger',
              'assets/images/focus.png',
              const Color.fromARGB(255, 244, 67, 54), // Red for Anger
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Envy',
              'assets/images/focus.png',
              const Color.fromARGB(255, 85, 107, 47), // Olive for Envy
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Embarrassment',
              'assets/images/focus.png',
              const Color.fromARGB(
                  255, 255, 87, 34), // Deep Orange for Embarrassment
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Ennui',
              'assets/images/focus.png',
              const Color.fromARGB(255, 158, 158, 158), // Grey for Ennui
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Nostalgia',
              'assets/images/focus.png',
              const Color.fromARGB(255, 121, 85, 72), // Brown for Nostalgia
            ),
            const SizedBox(width: 16),
            _buildMoodFace(
              context,
              color,
              'Sadness',
              'assets/images/focus.png',
              const Color.fromARGB(255, 33, 150, 243), // Light Blue for Sadness
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodFace(
    BuildContext context,
    ColorScheme color,
    String mood,
    String assetPath,
    Color moodColor,
  ) {
    String lottieUrl;

    // Set Lottie URL based on the mood
    switch (mood) {
      case 'Joy':
        lottieUrl =
            'https://lottie.host/830c5360-bc5f-4420-8694-eafe78fb2f52/qWxhp3WN18.json';
        break;
      case 'Fear':
        lottieUrl =
            'https://lottie.host/2d829e2f-1213-40bf-b276-ca0bf2c05aff/IdDjaM9tay.json';
        break;
      case 'Disgust':
        lottieUrl =
            'https://lottie.host/bcb22601-fc69-4dbc-8c36-21770d172065/xUlpUDRbSl.json';
        break;
      case 'Anger':
        lottieUrl =
            'https://lottie.host/fa31fa94-4c83-4fb8-aab2-58d71c338420/LLahDEHSPi.json';
        break;
      case 'Envy':
        lottieUrl =
            'https://lottie.host/6343d04f-b1f0-4c88-b004-cab177474477/vlDp9Xcx41.json';
        break;
      case 'Embarrassment':
        lottieUrl =
            'https://lottie.host/ca64cf76-5b78-46c8-9079-3e134b118733/XzOixmHiaQ.json';
        break;
      case 'Ennui':
        lottieUrl =
            'https://lottie.host/c4896915-d3fa-46db-8795-8c8206589b1c/rqYkrCtrL3.json';
        break;
      case 'Nostalgia':
        lottieUrl =
            'https://lottie.host/130b6c49-73bf-4f6d-846c-c2102ccfbd79/ktAs4FJfYw.json';
        break;
      case 'Sadness':
        lottieUrl =
            'https://lottie.host/4eb8ebe9-00b8-4ed3-a824-b9f3ad6c79eb/6VCH5rEpGQ.json';
        break;
      default:
        lottieUrl = 'https://lottie.host/default-animation-url.json';
    }

    return GestureDetector(
      onTap: () => _handleMoodSelection(context, mood),
      child: MouseRegion(
        onEnter: (_) => _showMoodPreview(context, mood),
        onExit: (_) => _hideMoodPreview(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 110,
          height: 110,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [moodColor.withOpacity(0.8), moodColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: moodColor.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Lottie.network(
                  lottieUrl,
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                child: Text(
                  mood,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Optional: Show mood preview when hovering over the mood face
  void _showMoodPreview(BuildContext context, String mood) {
    // Implement your mood preview logic here (e.g., show a tooltip or popup)
  }

  void _hideMoodPreview(BuildContext context) {
    // Implement hiding logic for mood preview here
  }

  Widget _buildMoodReportsButton(BuildContext context, ColorScheme color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MoodReportView(
                    mood: '',
                    userId: '',
                    selectedMood: '',
                  )),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color.primary,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)), // Rounded button
      ),
      child: const Text('View My Mood Reports'),
    );
  }

  Widget _buildTodayTaskTitle(ColorScheme color) {
    return Text(
      'Today\'s Tasks',
      style: TextStyle(
        color: color.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPeerGroupTask(ColorScheme color, BuildContext context) {
    // Get the screen width to calculate dynamic padding and font sizes
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const PeerGroupView(), // Replace with your destination screen
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Define the slide transition
              const begin = Offset(1.0, 0.0); // Start from the right side
              const end = Offset.zero; // End at the normal position
              const curve =
                  Curves.easeInOut; // Define the curve of the transition

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              // Return a SlideTransition that animates the child from right to left
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Task(
        title: 'Mental Health Announcement',
        subtitle: 'Stay informed about upcoming seminars and events.',
        backgroundColor: color.primary,
        foregroundColor: Colors.white,
        textButton: 'Learn More', // Updated button title
        iconData: Icons.announcement,
        taskName: 'Seminar Announcement',
        description:
            'Discover seminars, workshops, and events related to mental health.',
        icon: Icons.announcement,
        color: color.primary,
        assetName:
            'assets/images/meetup.png', // Update with the appropriate image if needed
        onTap: () {},

        padding: EdgeInsets.symmetric(
          horizontal: screenWidth *
              0.05, // Apply horizontal padding based on screen width
          vertical: screenWidth *
              0.02, // Apply vertical padding based on screen width
        ),
        titleFontSize: screenWidth > 600
            ? 22
            : 18, // Update title font size for larger screens
        subtitleFontSize: screenWidth > 600
            ? 16
            : 14, // Update subtitle font size for larger screens
      ),
    );
  }

  Widget _buildMeditationTask(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MeditationView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Define the slide transition
              const begin = Offset(1.0, 0.0); // Start from the right side
              const end = Offset.zero; // End at the normal position
              const curve =
                  Curves.easeInOut; // Define the curve of the transition

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              // Return a SlideTransition that animates the child from right to left
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
      },
      child: Task(
        title: 'Meditation Session',
        subtitle: 'Relax and unwind with a guided session.',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        textButton: 'Start Now',
        iconData: Icons.self_improvement,
        taskName: 'Meditation',
        description: 'A guided meditation session.',
        icon: Icons.self_improvement,
        color: Colors.green,
        assetName: 'assets/images/meditation.png',
        onTap: () {},
        // Adjust the Task widget layout based on screen width
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Apply horizontal padding
          vertical: screenWidth * 0.02, // Apply vertical padding
        ),
        // You can also modify other parameters like font size or icon size based on the screen size
        titleFontSize:
            screenWidth > 600 ? 22 : 18, // Bigger title on larger screens
        subtitleFontSize:
            screenWidth > 600 ? 16 : 14, // Adjust subtitle font size
      ),
    );
  }

  void _handleMoodSelection(BuildContext context, String mood) async {
    // Save mood to Firebase
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final moodRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('moods');

    await moodRef.add({
      'mood': mood,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show a SnackBar indicating the mood has been saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood "$mood" is saved!'),
        duration: const Duration(seconds: 2), // Duration for the SnackBar
      ),
    );

    // Wait for the SnackBar to finish before navigating
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to GospelScreen with the selected moodType
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GospelScreen(
          moodType: mood, // Pass the selected mood here
        ),
      ),
    );
  }
}
