// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xff8E97FD);
  static Color get secondary => const Color(0xff3F414E);
  static Color get tertiary => const Color(0xffEBEAEC);
  static Color get sleep => const Color(0xff03174C);
  static Color get sleepText => const Color(0xffE6E7F2);
  static const Color mentalHealthPrimary = Color(0xFF4CAF50); // A calming green
  static const Color yellow = Color(0xFFFFEB3B); // Custom yellow color
  static const Color mentalHealthAccent =
      Color(0xFF8BC34A); // A lighter green for accents
  static const Color textPrimary =
      Color(0xFFFFFFFF); // White for text on dark backgrounds
  static const Color textSecondary =
      Color(0xFF000000); // Black for text on light backgrounds

  static const Color buttoncolor = Color.fromARGB(255, 66, 223, 4);

  static var green; // Black for text on light backgrounds

  static Color get primaryTextW => const Color(0xffF6F1FB);
  static Color get secondaryText => const Color(0xffA1A4B2);
  static Color get txtBG => const Color(0xffF2F3F7);
  static Color get orange => const Color(0xffFD6B68);
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  Future push(Widget widget) async {
    return Navigator.push(
        this, MaterialPageRoute(builder: (context) => widget));
  }

  void pop() async {
    return Navigator.pop(this);
  }
}

extension HexColor on Color {
  static Color formHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst("#", ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
