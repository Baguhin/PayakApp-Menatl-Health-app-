// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>? ?? {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6BBF9B),
      ),
      body: user == null || userData == null
          ? const Center(child: Text("No user data available."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 20.0),
                  _buildMoodCard(),
                  const SizedBox(height: 20.0),
                  _buildAboutMeCard(),
                  const SizedBox(height: 20.0),
                  _buildAdditionalInfoCard(),
                  const SizedBox(height: 20.0),
                  _buildProgressTracker(),
                  const SizedBox(height: 20.0),
                  _buildFavoriteActivities(),
                  const SizedBox(height: 20.0),
                  _buildGoalsCard(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6BBF9B), Color(0xFF4DAF90)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : const AssetImage('assets/placeholder.jpg') as ImageProvider,
          ),
          const SizedBox(height: 12.0),
          Text(
            userData?['displayName'] ?? 'User Name',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            user?.email ?? 'user@example.com',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildMoodCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Mood',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.sentiment_satisfied, size: 40),
                const SizedBox(width: 8.0),
                Text(userData?['mood'] ?? '😊 Happy',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('About Me',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(userData?['bio'] ?? 'No bio available',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Additional Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8.0),
                Text('📞 ${userData?['phone'] ?? 'Not provided'}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 8.0),
                Text('📍 ${userData?['location'] ?? 'Not provided'}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.date_range, size: 18),
                const SizedBox(width: 8.0),
                Text(
                    '📅 Member since: ${userData?['memberSince'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTracker() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progress Tracker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(
              'Meditation sessions completed: ${userData?['meditationSessions'] ?? 0}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Journal entries: ${userData?['journalEntries'] ?? 0}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteActivities() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favorite Activities',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(userData?['favoriteActivities']?.join(', ') ?? 'None',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Goals',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(userData?['goals']?.join(', ') ?? 'No goals set',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
