// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_import, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tangullo/ui/views/profile/update.dart';
import 'package:tangullo/ui/views/profile/profile_menu.dart';

class User {
  final String name;
  final String bio;
  final String email;
  final String phone;
  final List<String> goals;
  final String profileImage;

  User({
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
    required this.goals,
    required this.profileImage,
  });
}

class ProfileScreen extends StatelessWidget {
  // Sample user data (replace this with actual user data retrieval)
  final User user = User(
    name: "John Chris",
    bio: "Mental health advocate and wellness coach.",
    email: "john.chris@example.com",
    phone: "+1 234 567 890",
    goals: [
      "Practice mindfulness daily",
      "Journaling to track emotions",
      "Attend therapy sessions regularly",
    ],
    profileImage: 'assets/johnchris.jpg',
  );

  ProfileScreen({Key? key}) : super(key: key);

  String get tProfile => "Profile";
  double get tDefaultSize => 20.0;
  Color get tPrimaryColor => Colors.blue;
  Color get tDarkColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          tProfile,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Toggle dark mode or perform related action here
            },
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(tDefaultSize),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        user.profileImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.error,
                          size: 120,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: tPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LineAwesomeIcons.arrow_alt_circle_down,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                user.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                user.bio,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),

              /// -- CONTACT INFO
              _buildContactInfo(context),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- GOALS
              _buildMentalHealthGoals(context),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child:
                      Text("Edit Profile", style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.copy,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Account Details",
                icon: LineAwesomeIcons.wallet_solid,
                onPress: () {},
              ),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info_solid,
                onPress: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Information",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Text("Email: ${user.email}"),
        Text("Phone: ${user.phone}"),
      ],
    );
  }

  Widget _buildMentalHealthGoals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mental Health Goals",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        for (var goal in user.goals) Text("• $goal"),
      ],
    );
  }
}
