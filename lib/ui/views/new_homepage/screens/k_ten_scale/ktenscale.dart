import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:tangullo/ui/views/new_homepage/screens/k_ten_scale/screens/welcome/welcome_screen.dart';

ktenScale() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
