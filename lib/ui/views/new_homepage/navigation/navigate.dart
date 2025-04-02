import 'package:flutter/material.dart';

import 'package:tangullo/ui/views/new_homepage/screens/patient_dashboard/fitness_app_home_screen.dart';
import 'package:tangullo/ui/views/new_homepage/screens/sign_in_page.dart';
import 'package:tangullo/ui/views/new_homepage/screens/sign_up_page.dart';
import 'package:tangullo/ui/views/new_homepage/screens/splashscreen.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/initial-screen': (context) => const Splashscreen(),
    '/sign-in': (context) => const SignInPage(
          title: '',
        ),
    '/sign-up': (context) => const SignUpPage(),
    '/home': (context) => const FitnessAppHomeScreen(
          title: '',
        ),
  };
}
