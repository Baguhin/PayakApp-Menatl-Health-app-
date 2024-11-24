// drawer_menu.dart
import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/home/assessment.dart';
import 'package:tangullo/ui/views/home/helpline.dart';
import 'package:tangullo/ui/views/home/smart_stress.dart';
import 'package:tangullo/ui/views/home/userfeedback.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerMenu extends StatelessWidget {
  final String userName;

  const DrawerMenu({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/johnchris.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hello, $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
              context, Icons.assessment, 'Assessment', const Assessment()),
          _buildDrawerItem(context, Icons.call, 'Helpline', const Helpline()),
          _buildDrawerItem(context, Icons.batch_prediction, 'Smart Prediction',
              const SmartStress()),
          _buildDrawerItem(
              context, Icons.feedback, 'User Feedback', const FeedbackPage()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        ZoomDrawer.of(context)?.close(); // Close the drawer before navigating
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  static of(BuildContext context) {}
}
