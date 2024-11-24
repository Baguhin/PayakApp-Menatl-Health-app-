import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'meditation_viewmodel.dart';

class MeditationView extends StackedView<MeditationViewModel> {
  const MeditationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MeditationViewModel viewModel,
    Widget? child,
  ) {
    final ColorScheme color = Theme.of(context).colorScheme; // Get ColorScheme
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double childAspectRatio =
        screenWidth / (screenHeight / 2); // Dynamically adjust aspect ratio

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: color.onPrimary,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Hey Sweetie!',
          style: TextStyle(
            color: color.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04), // Responsive horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "What's your mood today?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.count(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                    shrinkWrap:
                        true, // Ensure the GridView adapts to its contents
                    crossAxisCount: screenWidth > 600
                        ? 3
                        : 2, // Adjust grid based on screen width
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20,
                    childAspectRatio:
                        childAspectRatio, // Use dynamic aspect ratio
                    children: [
                      _buildMoodCard('Meditate', 'Breath',
                          'assets/meditation/meditation.png', () {
                        viewModel.navigateToMeditationPage(context);
                      }),
                      _buildMoodCard('Relax', 'Relaxing Music',
                          'assets/meditation/relax.png', () {
                        viewModel.navigateToRelaxPage(context);
                      }),
                      _buildMoodCard(
                          'Brain', 'Calm', 'assets/meditation/brain.png', () {
                        viewModel.navigateToCalmPage(context);
                      }),
                      _buildMoodCard(
                          'Journal', 'Learn', 'assets/meditation/study.png',
                          () {
                        viewModel.navigateToJournalizing(context);
                      }),
                      _buildMoodCard('Sleep', 'Good Night Stories',
                          'assets/meditation/sleep.png', () {
                        viewModel.navigateToSleppStories(context);
                      }),
                      _buildMoodCard('Breathe', 'Breathing Exercise',
                          'assets/meditation/breathe.png', () {
                        viewModel.navigateToBreathExercisePage(context);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodCard(
      String title, String subtitle, String assetName, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8,
        shadowColor: Colors.black45,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  assetName,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Create a custom page route with a transition
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Custom transition: Slide from the right
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration:
          const Duration(milliseconds: 500), // Set transition duration
    );
  }

  @override
  MeditationViewModel viewModelBuilder(BuildContext context) =>
      MeditationViewModel();
}
