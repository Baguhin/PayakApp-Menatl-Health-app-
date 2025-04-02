// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/login/login_view.dart';
import 'package:tangullo/ui/views/profile/profile.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF), // Soft background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color.primary,
        title: Text(
          'Settings',
          style: TextStyle(color: color.onPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width *
            0.05), // Add padding using MediaQuery
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            _buildSectionTitle('Settings', color),
            const SizedBox(height: 10),

            // Account Settings
            _buildListTile(
              context,
              icon: Icons.person_outline,
              title: 'Account',
              subtitle: 'Update your profile information',
              onTap: () {
                // Navigate to ProfileView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen()), // Make sure ProfileView is imported
                );
              },
            ),
            const Divider(),

            // Theme Settings
            _buildListTile(
              context,
              icon: Icons.color_lens_outlined,
              title: 'Theme',
              subtitle: 'Choose your app theme',
              onTap: () {
                // Navigate to theme selection or toggle theme
              },
            ),
            const Divider(),

            // Notifications Settings
            _buildListTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {
                // Navigate to notification settings
              },
            ),
            const Divider(),

            // Privacy & Security Settings
            _buildListTile(
              context,
              icon: Icons.lock_outline,
              title: 'Privacy & Security',
              subtitle: 'Adjust your privacy settings',
              onTap: () {
                // Navigate to privacy settings
              },
            ),
            const Divider(),

            // Language Settings
            _buildListTile(
              context,
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'Select your preferred language',
              onTap: () {
                // Navigate to language selection
              },
            ),
            const Divider(),

            // Help & Support
            _buildListTile(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get assistance with the app',
              onTap: () {
                // Navigate to help and support
              },
            ),
            const Divider(),

            // Additional Settings
            _buildListTile(
              context,
              icon: Icons.data_usage,
              title: 'Data Usage',
              subtitle: 'Manage your data usage preferences',
              onTap: () {
                // Navigate to data usage settings
              },
            ),
            const Divider(),

            // Feedback
            _buildListTile(
              context,
              icon: Icons.feedback,
              title: 'Feedback',
              subtitle: 'Send us your feedback',
              onTap: () {
                // Navigate to feedback form
              },
            ),
            const Divider(),

            // About
            _buildListTile(
              context,
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Learn more about the app',
              onTap: () {
                // Navigate to about page
              },
            ),
            const Divider(),

            // Logout Button as a ListTile
            const SizedBox(height: 20),
            _buildListTile(
              context,
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () async {
                await _logoutUser(context);
              },
              isLogout: true, // Flag to customize the Logout button
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel();

  Widget _buildSectionTitle(String title, ColorScheme color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color.onSurface,
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.redAccent : Colors.teal),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : null, // Change color for Logout
        ),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Future<void> _logoutUser(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference userRef =
          FirebaseDatabase.instance.ref('users/${user.uid}');

      // Don't await update to avoid delay
      userRef.update({'isLoggedIn': false});
    }

    // Sign out the user and go offline in parallel
    await Future.wait([
      FirebaseAuth.instance.signOut(),
      FirebaseDatabase.instance.goOffline(),
    ]);

    // Navigate immediately after calling logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView(title: '')),
      (route) => false,
    );
  }
}
