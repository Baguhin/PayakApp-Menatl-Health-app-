import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tangullo/ui/views/new_homepage/screens/dashboard_doctor.dart';
import 'package:tangullo/ui/views/new_homepage/screens/sign_up_page.dart';

import 'k_ten_scale/ktenscale.dart';

late User user;

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email Verification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignUpPage()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'An email has been sent to ${user.email}. \nPlease Verify!'),
          ),
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('login_as') == "doctor") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DoctorDashBoard()));
      } else if (prefs.getString('login_as') == "patient") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ktenScale()));
      }
    }
  }
}
