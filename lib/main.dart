import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tangullo/ui/views/admin/admindashboard.dart';
import 'package:tangullo/ui/views/admin/anouncement.dart';
import 'package:tangullo/ui/views/admin/create_doctor_page.dart';
import 'package:tangullo/ui/views/admin/manageReport.dart';
import 'package:tangullo/ui/views/admin/manageseminar.dart';
import 'package:tangullo/ui/views/admin/servises_feedback.dart';
import 'package:tangullo/ui/views/admin/view_reports_page.dart';
import 'package:tangullo/ui/views/assesment/adhd.dart';
import 'package:tangullo/ui/views/assesment/anxietytest.dart';
import 'package:tangullo/ui/views/assesment/bipolar.dart';
import 'package:tangullo/ui/views/assesment/depression.dart';
import 'package:tangullo/ui/views/assesment/eating.dart';
import 'package:tangullo/ui/views/assesment/ocdtest.dart';
import 'package:tangullo/ui/views/assesment/ptsd.dart';
import 'package:tangullo/ui/views/assesment/stress.dart';
import 'package:tangullo/ui/views/login/login_view.dart';
import 'package:tangullo/ui/views/messages/messages_view.dart';
import 'package:tangullo/ui/views/navigation/homepage_view.dart';
import 'package:tangullo/ui/views/providers/sleep.dart';
import 'package:tangullo/ui/views/providers/providers.dart'; // Ensure StepCounterProvider is also imported
import 'package:provider/provider.dart';
import 'package:tangullo/ui/views/seminar_coping_worksop/create_seminar_page.dart';
import 'package:tangullo/ui/views/signup/signup_view.dart';
import 'package:tangullo/ui/views/splashscreen/splashscreen_view.dart';
import 'package:tangullo/ui/views/superadmin/adminmanagement.dart';

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

  runApp(
    MultiProvider(
      // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => StepCounterProvider()),
        ChangeNotifierProvider(create: (context) => SleepMonitorProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        '/manageVolunteers': (context) => const CreateDoctorPage(),
        '/admin-management': (context) => const AdminManagementView(),
        '/view_service_feedback': (context) => const ViewServiceFeedbackPage(),
        '/manageMentalHealthAnnouncements': (context) =>
            const ManageMentalHealthAnnouncementsView(),
        '/mentalHealthSeminarAnnouncements': (context) =>
            const CreateMentalHealthSeminarPage(),
        '/manageReports': (context) => const managereportPage(),
        '/messages': (context) => const MessagesView(),
        // Route for messaging view

        '/test/anxiety': (context) =>
            const AnxietyTestScreen(key: Key("AnxietyTestScreen")),
        '/test/ocd': (context) =>
            const OCDTestScreen(key: Key("OCDTestScreen")),
        '/test/stress': (context) =>
            const StressTestScreen(key: Key("StressTestScreen")),
        '/test/bipolar': (context) =>
            const BipolarTestScreen(key: Key("BipolarTestScreen")),
        '/test/ptsd': (context) =>
            const PTSDTestScreen(key: Key("PTSDTestScreen")),
        '/test/eating': (context) => const EatingDisorderTestScreen(
            key: Key("EatingDisorderTestScreen")),
        '/test/adhd': (context) =>
            const ADHDTestScreen(key: Key("ADHDTestScreen")),
        '/test/depression': (context) => const DepressionTestScreen(),
      },
    );
  }
}
