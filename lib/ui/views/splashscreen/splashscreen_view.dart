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
          Positioned.fill(
            child: Image.asset(
              'assets/images21/logs.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: LottieBuilder.asset(
                'assets/loading_animation.json',
                height: 100,
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

  /// ✅ Fetch User Role from Firebase Authentication & Realtime Database
  Future<String?> checkUserAuthentication() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user != null) {
        if (kDebugMode) {
          print("✅ User logged in: ${user.email}");
        }

        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users').child(user.uid);
        DatabaseEvent event = await userRef.once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists && snapshot.value != null) {
          Map<String, dynamic> userData =
              Map<String, dynamic>.from(snapshot.value as Map);

          // ✅ Check for superadmin by email
          if (user.email == "johnchrisbaguhin@gmail.com") {
            return 'superadmin';
          }

          // ✅ If "role" exists, use it. Otherwise, check "isAdmin"
          if (userData.containsKey('role')) {
            String role = userData['role'].toString().trim().toLowerCase();
            if (kDebugMode) {
              print("✅ User role from Firebase: $role");
            }
            return role;
          } else if (userData.containsKey('isAdmin') &&
              userData['isAdmin'] == true &&
              userData.containsKey('isEnabled') &&
              userData['isEnabled'] == true) {
            return 'admin'; // ✅ Default to "admin" if isAdmin is true and user is enabled
          }
        }
      }
      return null; // If user data or role does not exist
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error in authentication check: $e');
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
