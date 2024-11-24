import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Task extends StatelessWidget {
  const Task({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetName,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconData,
    required this.taskName,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.textButton,
    required EdgeInsets padding,
    required int titleFontSize,
    required int subtitleFontSize,
  });

  final String title;
  final String subtitle;
  final String assetName;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData iconData;
  final String taskName;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String textButton;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: screenWidth > 600
              ? 180
              : 165, // Adjust height based on screen width
          padding: EdgeInsets.symmetric(
            horizontal:
                screenWidth * 0.05, // Adjust padding based on screen width
            vertical: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.primaryFixed,
            ),
            color: backgroundColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.alegreya(
                    color: colorScheme.onPrimary,
                    fontSize: screenWidth > 600
                        ? 28
                        : 25, // Adjust text size based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.2), // Adjust padding for subtitle
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Icon(
                      iconData,
                      size: 20,
                      color: foregroundColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Optional overlay icon with responsive positioning
        Align(
          alignment: Alignment.centerRight,
          child: Transform.translate(
            offset: Offset(
                -screenWidth * 0.05,
                screenWidth > 600
                    ? 50
                    : 40), // Adjust overlay icon position based on screen size
            child: Image.asset(
              assetName,
              height: screenWidth > 600
                  ? 70
                  : 62.14, // Adjust image size based on screen size
              width: screenWidth > 600
                  ? 90
                  : 80, // Adjust image size based on screen size
            ),
          ),
        ),
        // Overlay action button with responsive size and position
        Positioned(
          right: screenWidth *
              0.05, // Adjust button position based on screen width
          bottom: screenWidth > 600
              ? 15
              : 5, // Adjust button position based on screen size
          child: MaterialButton(
            onPressed: onTap,
            color: color, // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(
              horizontal:
                  screenWidth * 0.08, // Adjust padding based on screen width
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon, // Use IconData directly here as well
                  color: Colors.white,
                  size: screenWidth > 600
                      ? 20
                      : 18, // Adjust icon size based on screen width
                ),
                const SizedBox(width: 5),
                Text(
                  textButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth > 600
                        ? 16
                        : 14, // Adjust text size based on screen width
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
