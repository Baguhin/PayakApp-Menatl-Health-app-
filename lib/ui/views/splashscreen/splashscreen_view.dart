// ignore_for_file: unused_local_variable

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/admin/superadmin.dart';
import 'package:tangullo/ui/views/navigation/homepage_view.dart';

import 'package:tangullo/ui/views/admin/admindashboard.dart';
import 'package:tangullo/ui/views/splashscreen/consult.dart';

import 'splashscreen_viewmodel.dart';

class SplashscreenView extends StackedView<SplashscreenViewModel> {
  const SplashscreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          Center(
            child: LottieBuilder.asset('assets/loading/splash.json'),
          ),
          const SizedBox(height: 20), // Reduced height for better spacing
          const Text(
            'PayakApp',
            style: TextStyle(
              fontSize: 36, // Increased font size
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 14, 13, 13),
              shadows: [
                Shadow(
                  color: Colors.grey,
                  offset: Offset(2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Adjusted spacing
          LottieBuilder.asset(
            'assets/loading_animation.json',
            height: 150, // Adjusted height
            width: 150, // Adjusted width
          ),
        ],
      ),
      nextScreen: FutureBuilder<String?>(
        // Unchanged
        future: checkUserAuthentication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('An error occurred. Please try again.'),
              ),
            );
          } else if (snapshot.hasData) {
            // Check for specific user email
            if (snapshot.data == 'johnchrisbaguhin@gmail.com') {
              return const SuperAdminDashboardView(); // Redirect to SuperAdminDashboard
            }
            // Navigate based on role
            switch (snapshot.data) {
              case 'superadmin':
                return const SuperAdminDashboardView();
              case 'admin':
                return const AdminDashboardView();
              case 'user':
              default:
                return const HomepageView(title: 'Welcome to PayakApp');
            }
          } else {
            return const OnBoarding();
          }
        },
      ),
      splashIconSize: 700,
      backgroundColor: const Color(0xFFE6F7FF), // Light background
      duration: 5000,
    );
  }

  @override
  SplashscreenViewModel viewModelBuilder(BuildContext context) =>
      SplashscreenViewModel();

  Future<String?> checkUserAuthentication() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user != null) {
        if (kDebugMode) {
          print("User is logged in: ${user.email}");
        }
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(user.uid);
        DataSnapshot snapshot = await userRef.get();

        if (snapshot.exists) {
          final userData = snapshot.value as Map;
          // Return user's email if it exists, else return role
          return user.email; // Return user email directly
        }
      }
      return null; // Return null if no user is authenticated
    } catch (e) {
      if (kDebugMode) {
        print('Error in authentication check: $e');
      }
      return null;
    }
  }

  @override
  Widget builder(BuildContext context, SplashscreenViewModel viewModel,
          Widget? child) =>
      throw UnimplementedError();
}
