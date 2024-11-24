// ignore_for_file: equal_keys_in_map

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/admin/anouncement.dart';
import 'package:tangullo/ui/views/admin/seminar.dart';
import 'package:tangullo/ui/views/admin/servises_feedback.dart';
import 'package:tangullo/ui/views/admin/view_reports_page.dart';
import 'package:tangullo/ui/views/navigation/homepage_view.dart';
import 'package:tangullo/ui/views/login/login_view.dart';
import 'package:tangullo/ui/views/signup/signup_view.dart';
import 'package:tangullo/ui/views/splashscreen/splashscreen_view.dart';
import 'package:tangullo/ui/views/messages/messages_view.dart';
import 'package:tangullo/ui/views/admin/admindashboard.dart';
import 'package:tangullo/ui/views/admin/manageReport.dart';
import 'package:tangullo/ui/views/admin/manageseminar.dart';
import 'package:tangullo/ui/views/superadmin/adminmanagement.dart';
import 'ui/views/admin/ExpertManagementPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    if (kDebugMode) {
      print("Firebase initialized successfully.");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error initializing Firebase: $e");
    }
    // If Firebase fails to initialize, exit the app
    return;
  }

  // Attempt to create the Super Admin account
  await createSuperAdmin();

  runApp(const MyApp());
}

/// Creates a Super Admin account in Firebase Auth and adds it to Realtime Database.
Future<void> createSuperAdmin() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  try {
    // Check if the Super Admin account already exists
    User? existingUser;
    await auth
        .fetchSignInMethodsForEmail('johnchrisbaguhin@gmail.com')
        .then((methods) {
      if (methods.isNotEmpty) {
        existingUser = auth.currentUser;
      }
    });

    if (existingUser == null) {
      // Create a new Super Admin account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: 'johnchrisbaguhin@gmail.com',
        password: '123456',
      );

      // Add user details to Realtime Database
      await databaseRef.child('users').child(userCredential.user!.uid).set({
        'displayName': 'Super Admin',
        'email': 'johnchrisbaguhin@gmail.com',
        'role': 'superadmin',
        'isVerified': true,
        'isEnabled': true,
      });

      if (kDebugMode) {
        print('Super Admin account created successfully.');
      }
    } else {
      if (kDebugMode) {
        print('Super Admin account already exists.');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error creating Super Admin account: $e');
    }
  }
}

/// Main Application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'payakApp',
      initialRoute: '/', // Set Splashscreen as the initial route
      routes: {
        '/': (context) => const SplashscreenView(),
        '/signup': (context) => const SignupView(),
        '/login': (context) => const LoginView(title: 'Login'),
        '/homepage': (context) => const HomepageView(title: ''),
        '/adminDashboard': (context) => const AdminDashboardView(),
        '/viewReports': (context) => const ViewReportsPage(),
        '/manageSeminars': (context) => const manageseminarPage(),
        '/manageVolunteers': (context) => const ExpertManagementPage(),
        '/admin-management': (context) => const AdminManagementView(),
        '/view_service_feedback': (context) => const ViewServiceFeedbackPage(),
        '/manageMentalHealthAnnouncements': (context) =>
            const ManageMentalHealthAnnouncementsView(),
        '/mentalHealthSeminarAnnouncements': (context) =>
            const MentalHealthSeminarAnnouncementsView(),
        '/manageReports': (context) => const managereportPage(),
        '/messages': (context) =>
            const MessagesView(), // Route for messaging view
      },
    );
  }
}
