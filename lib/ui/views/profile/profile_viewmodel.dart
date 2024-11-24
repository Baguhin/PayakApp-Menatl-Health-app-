import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends BaseViewModel {
  String? userName;

  ProfileViewModel() {
    loadUserProfile(); // Load the user profile when ViewModel is created
  }

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch the display name from Firebase Auth
      userName = user.displayName ??
          'User'; // Default to 'User' if no display name is set
    } else {
      userName = 'Guest'; // Default if no user is logged in
    }
    notifyListeners(); // Notify the view of changes
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
}
