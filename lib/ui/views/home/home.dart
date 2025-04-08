import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:tangullo/ui/views/home/helpline.dart';
import 'package:tangullo/ui/views/home/peer.dart';
import 'package:tangullo/ui/views/home/sleep/live_detection/live_home.dart';
import 'package:tangullo/ui/views/home/sleep/sleep_tracking.dart';

import 'package:tangullo/ui/views/meditation/meditation_view.dart';

import 'package:tangullo/ui/views/mood_tracking%20page/gospel_screen.dart';

import 'package:tangullo/ui/views/settings/settings_view.dart';
import 'package:tangullo/ui/views/track_workout.dart';
import 'package:tangullo/widgets/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../mood_tracking page/allreportview.dart';

import '../new_homepage/screens/patient_dashboard/my_diary/my_diary_screen.dart';
import 'userfeedback.dart';

class Home extends StatefulWidget {
  final String userName;

  const Home({super.key, required this.userName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static const List<String> quotes = [
    "Believe you can and you're halfway there.",
    "The only way to do great work is to love what you do.",
    "You are never too old to set another goal or to dream a new dream.",
    "Success is not how high you have climbed, but how you make a positive difference to the world.",
    "The best way to predict the future is to create it.",
    "Your limitation—it's only your imagination.",
    "Push yourself, because no one else is going to do it for you.",
    "Mental health is not a destination, but a journey.",
    "Self-care is how you take your power back.",
    "You are worthy of your own time and attention.",
  ];

  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;

  // Store the quote once when the state is initialized
  late String _currentQuote;

  @override
  void initState() {
    super.initState();
    // Select a random quote once during initialization
    _currentQuote = quotes[Random().nextInt(quotes.length)];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scrollController.addListener(() {
      // Only update state if the elevation status changes to minimize rebuilds
      bool shouldShowElevation = _scrollController.offset > 10;
      if (_showElevation != shouldShowElevation) {
        setState(() {
          _showElevation = shouldShowElevation;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA), // Lighter, more neutral background
      appBar: AppBar(
        elevation: _showElevation ? 4 : 0,
        backgroundColor: color.primary,
        leadingWidth: 40,
        toolbarHeight: 50, // Better height that's not too small
        title: Row(
          children: [
            Image.asset(
              'assets/tink.png', // Replace with your app logo
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'PayakApp',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: 18,
              ),
            ),
          ],
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: NotificationListener<ScrollNotification>(
        // Use NotificationListener for smoother scrolling performance
        onNotification: (notification) {
          // Return true to cancel the notification bubbling
          return true;
        },
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          physics:
              const BouncingScrollPhysics(), // Add bouncing physics for smoother scroll
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInspiringQuote(color),
                  const SizedBox(height: 25),
                  _buildFeelingQuestion(color),
                  const SizedBox(height: 15),
                  _buildMoodSelection(context, color),
                  const SizedBox(height: 30),
                  _buildMoodReportsButton(context, color),
                  const SizedBox(height: 30),
                  _buildTodayTaskTitle(color),
                  const SizedBox(height: 15),
                  _buildPeerGroupTask(color, context),
                  const SizedBox(height: 20),
                  _buildMeditationTask(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              Colors.white,
            ],
            stops: const [0, 0.2, 0.2],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/user.jpg',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Hello, ${widget.userName}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildDrawerItem(
              context,
              Icons.settings,
              'Settings',
              const SettingsView(),
              Colors.blueGrey,
            ),
            _buildDrawerItem(
              context,
              Icons.call,
              'Helpline',
              const Helpline(),
              Colors.green,
            ),
            _buildDrawerItem(
              context,
              Icons.face_3_rounded,
              'Live Face Detection',
              const Landing(),
              Colors.purple,
            ),
            _buildDrawerItem(
              context,
              Icons.feedback,
              'User Feedback',
              const FeedbackPage(),
              Colors.amber,
            ),
            _buildDrawerItem(
              context,
              Icons.track_changes,
              'My Diary',
              const MyDiaryScreen(),
              Colors.teal,
            ),
            _buildDrawerItem(
              context,
              Icons.directions_walk,
              'Steps Counter',
              const StepCounterScreen(),
              Colors.indigo,
            ),
            _buildDrawerItem(
              context,
              Icons.nightlight_round,
              'Sleep Tracker',
              const SleepMonitorScreen(),
              Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      Widget destination, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildInspiringQuote(ColorScheme color) {
    // Use the stored quote instead of generating a new one on each build
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.primary.withOpacity(0.8),
            color.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.primary.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.format_quote,
                color: Colors.white.withOpacity(0.7),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _currentQuote, // Use the stored quote
            style: GoogleFonts.lora(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.format_quote,
                color: Colors.white.withOpacity(0.7),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeelingQuestion(ColorScheme color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        'How are you feeling today?',
        style: GoogleFonts.montserrat(
          color: color.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMoodSelection(BuildContext context, ColorScheme color) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildMoodFace(
            context,
            color,
            'Joy',
            'assets/images21/happy.png',
            const Color(0xFFFFD700), // Golden Yellow for Joy
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Fear',
            'assets/images21/calm.png',
            const Color(0xFF3F51B5), // Indigo for Fear
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Disgust',
            'assets/images21/relax.png',
            const Color(0xFF4CAF50), // Green for Disgust
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Anger',
            'assets/images21/focus.png',
            const Color(0xFFF44336), // Red for Anger
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Envy',
            'assets/images21/focus.png',
            const Color(0xFF556B2F), // Olive for Envy
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Embarrassment',
            'assets/images21/focus.png',
            const Color(0xFFFF5722), // Deep Orange for Embarrassment
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Ennui',
            'assets/images21/focus.png',
            const Color(0xFF9E9E9E), // Grey for Ennui
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Nostalgia',
            'assets/images21/focus.png',
            const Color(0xFF795548), // Brown for Nostalgia
          ),
          const SizedBox(width: 16),
          _buildMoodFace(
            context,
            color,
            'Sadness',
            'assets/images21/focus.png',
            const Color(0xFF2196F3), // Light Blue for Sadness
          ),
        ],
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
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              moodColor.withOpacity(0.7),
              moodColor,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: moodColor.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: -5,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(5),
              child: Lottie.network(
                lottieUrl,
                fit: BoxFit.contain,
                animate: true,
                // Add caching for better performance and to prevent reloading
                frameRate: FrameRate.max,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mood,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // These methods are kept for compatibility but not used anymore
  void _showMoodPreview(BuildContext context, String mood) {}
  void _hideMoodPreview(BuildContext context) {}

  Widget _buildMoodReportsButton(BuildContext context, ColorScheme color) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.primary.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: -5,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color.primary,
            Color.lerp(color.primary, Colors.teal, 0.6) ?? color.primary,
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodReportView(
                  mood: '',
                  userId: '',
                  selectedMood: '',
                ),
              ),
            );
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.analytics_outlined,
                    size: 22, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'View My Mood Reports',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayTaskTitle(ColorScheme color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Today\'s Tasks',
            style: GoogleFonts.montserrat(
              color: color.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Show more tasks or settings
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.more_horiz),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeerGroupTask(ColorScheme color, BuildContext context) {
    // Get the screen width to calculate dynamic padding and font sizes
    double screenWidth = MediaQuery.of(context).size.width;

    return Hero(
      tag: 'peer_group_tag', // Add Hero animation for smoother transitions
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.primary.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const PeerGroupView(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                            position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                splashColor: Colors.white.withOpacity(0.1),
                child: Task(
                  title: 'Mental Health Announcement',
                  subtitle: 'Stay informed about upcoming seminars and events.',
                  backgroundColor: color.primary,
                  foregroundColor: Colors.white,
                  textButton: 'Learn More',
                  iconData: Icons.announcement,
                  taskName: 'Seminar Announcement',
                  description:
                      'Discover seminars, workshops, and events related to mental health.',
                  icon: Icons.announcement,
                  color: color.primary,
                  assetName: 'assets/images21/meetup.png',
                  onTap: () {},
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenWidth * 0.03,
                  ),
                  titleFontSize: screenWidth > 600 ? 22 : 18,
                  subtitleFontSize: screenWidth > 600 ? 16 : 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationTask(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Color meditationColor = Colors.teal.shade600;

    return Hero(
      tag: 'meditation_tag', // Add Hero animation for smoother transitions
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: meditationColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const MeditationView(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                            position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                splashColor: Colors.white.withOpacity(0.1),
                child: Task(
                  title: 'Relaxing Session',
                  subtitle:
                      'Relax and unwind with a guided meditation session.',
                  backgroundColor: meditationColor,
                  foregroundColor: Colors.white,
                  textButton: 'Start Now',
                  iconData: Icons.self_improvement,
                  taskName: 'Meditation',
                  description: 'A guided meditation session.',
                  icon: Icons.self_improvement,
                  color: meditationColor,
                  assetName: 'assets/images21/meditation.png',
                  onTap: () {},
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenWidth * 0.03,
                  ),
                  titleFontSize: screenWidth > 600 ? 22 : 18,
                  subtitleFontSize: screenWidth > 600 ? 16 : 14,
                ),
              ),
            ),
          ),
        ),
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
