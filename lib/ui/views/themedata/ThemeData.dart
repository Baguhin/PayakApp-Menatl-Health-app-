// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppTheme {
  static const MaterialColor primaryColor = MaterialColor(
    0xFF007991, // Primary color value
    <int, Color>{
      50: Color(0xFFE0F7FA), // Shade 50
      100: Color(0xFFB2EBF2), // Shade 100
      200: Color(0xFF80DEEA), // Shade 200
      300: Color(0xFF4DD0E1), // Shade 300
      400: Color(0xFF26C6DA), // Shade 400
      500: Color(0xFF00BCD4), // Shade 500
      600: Color(0xFF00ACC1), // Shade 600
      700: Color(0xFF0097A7), // Shade 700
      800: Color(0xFF00838F), // Shade 800
      900: Color(0xFF006064), // Shade 900
    },
  );
  static const Color accentColor = Color(0xFF92FE9D);
  static const Color secondaryColor = Color(0xFF78ffd6);
  static const Color backgroundColor = Color(0xFF007991);
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.white70;

  static final ThemeData theme = ThemeData(
    primarySwatch: primaryColor,
    hintColor: accentColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
    ),
  );
}
