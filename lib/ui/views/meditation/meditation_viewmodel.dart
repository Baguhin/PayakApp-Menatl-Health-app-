import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/categories/index.dart';
import 'package:tangullo/ui/views/journalizing/journalizing_view.dart';
import 'package:tangullo/ui/views/meditation/breath/BreathExercisePage.dart';
import 'package:tangullo/ui/views/meditation/calm/calm.dart';
import 'package:tangullo/ui/views/meditation/goodnightstories/sleepstories.dart';
import 'package:tangullo/ui/views/new_homepage/screens/patient_dashboard/training/training_home_screen.dart';

class MeditationViewModel extends BaseViewModel {
  // Update these navigation methods to use custom transition

  void navigateToMeditationPage(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const TrainingScreen()),
    );
  }

  void navigateToRelaxPage(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const MusicScreen()),
    );
  }

  void navigateToCalmPage(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const CalmExercisePage()),
    );
  }

  void navigateToJournalizing(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const JournalizingView()),
    );
  }

  void navigateToSleppStories(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const SleepStoriesPage()),
    );
  }

  void navigateToBreathExercisePage(BuildContext context) {
    Navigator.push(
      context,
      _createPageRoute(const BreathExercisePage()),
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
}
