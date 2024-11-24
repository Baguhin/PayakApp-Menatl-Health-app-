import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Ensures no back arrow is added
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.teal.shade400,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9, // Adjust ratio for better spacing
          children: [
            _buildDashboardCard(
              context,
              title: 'View Reports',
              icon: Icons.bar_chart,
              color: Colors.orange,
              backgroundColor: Colors.orange.shade100,
              imagePath: 'assets/images/reports.png',
              onTap: () {
                Navigator.pushNamed(context, '/viewReports');
              },
            ),
            _buildDashboardCard(
              context,
              title: 'Services Feedback',
              icon: Icons.event,
              color: Colors.green,
              backgroundColor: Colors.green.shade100,
              imagePath: 'assets/images/seminars.png',
              onTap: () {
                // Navigate to the ViewServiceFeedbackPage
                Navigator.pushNamed(context, '/view_service_feedback');
              },
            ),
            _buildDashboardCard(
              context,
              title: 'Manage Volunteers',
              icon: Icons.volunteer_activism,
              color: Colors.purple,
              backgroundColor: Colors.purple.shade100,
              imagePath: 'assets/images/therapsit.png',
              onTap: () {
                Navigator.pushNamed(context, '/manageVolunteers');
              },
            ),
            _buildDashboardCard(
              context,
              title: 'Manage Reports',
              icon: Icons.report,
              color: Colors.red,
              backgroundColor: Colors.red.shade100,
              imagePath: 'assets/images/manage.png',
              onTap: () {
                Navigator.pushNamed(context, '/manageReports');
              },
            ),
            // Add Manage Mental Health Announcement
            _buildDashboardCard(
              context,
              title: 'Manage Mental Health Announcements',
              icon: Icons.notifications_active,
              color: Colors.blue,
              backgroundColor: Colors.blue.shade100,
              imagePath:
                  'assets/images/mental_health_announcement.png', // Add your image path here
              onTap: () {
                Navigator.pushNamed(
                    context, '/manageMentalHealthAnnouncements');
              },
            ),
            // Add Mental Health Seminar Announcement
            _buildDashboardCard(
              context,
              title: 'Mental Health Seminar Announcements',
              icon: Icons.school,
              color: Colors.teal,
              backgroundColor: Colors.teal.shade100,
              imagePath:
                  'assets/images/seminar_announcement.png', // Add your image path here
              onTap: () {
                Navigator.pushNamed(
                    context, '/mentalHealthSeminarAnnouncements');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Color backgroundColor,
      required String imagePath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8, // Higher elevation for better shadow
        shadowColor: Colors.grey.withOpacity(0.5), // Darker shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [backgroundColor, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Ensure full-width card content
            children: [
              Expanded(
                child: Image.asset(imagePath, height: 50),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                icon,
                size: 30,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
