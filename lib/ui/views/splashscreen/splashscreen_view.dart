import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/admin/superadmin.dart';
import 'package:tangullo/ui/views/navigation/homepage_view.dart';
import 'package:tangullo/ui/views/admin/admindashboard.dart';
import 'package:tangullo/ui/views/splashscreen/consult.dart';
import 'splashscreen_viewmodel.dart';
import 'package:lottie/lottie.dart';

class SplashscreenView extends StackedView<SplashscreenViewModel> {
  const SplashscreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/logs.png', // Ensure the image is correctly placed in assets
              fit: BoxFit.cover,
            ),
          ),
          // Bottom Positioned Lottie Animation
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 50), // Adjust spacing from bottom
              child: LottieBuilder.asset(
                'assets/loading_animation.json',
                height: 100, // Adjust height for a balanced look
                width: 100,
              ),
            ),
          ),
        ],
      ),
      nextScreen: FutureBuilder<String?>(
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
            if (snapshot.data == 'johnchrisbaguhin@gmail.com') {
              return const SuperAdminDashboardView();
            }
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
      splashIconSize: double.infinity,
      backgroundColor: Colors.transparent,
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
          return user.email;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error in authentication check: $e');
      }
      return null;
    }
  }

  @override
  Widget builder(
      BuildContext context, SplashscreenViewModel viewModel, Widget? child) {
    throw UnimplementedError();
  }
}
