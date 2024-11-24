// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/home/viewfeedback.dart';

class SuperAdminDashboardView extends StatelessWidget {
  const SuperAdminDashboardView({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Super Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Super Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.people,
              text: 'Admin Management',
              onTap: () => Navigator.pushNamed(context, '/admin-management'),
            ),
            _buildDrawerItem(
              icon: Icons.analytics,
              text: 'Reports & Analytics',
              onTap: () {
                // Navigate to analytics page
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                // Navigate to settings page
              },
            ),
            _buildDrawerItem(
              icon: Icons.person,
              text: 'Manage All Users',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementPage(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              color: Colors.redAccent,
              onTap: () => _logout(context),
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
          children: [
            _DashboardCard(
              icon: Icons.people,
              title: 'Admin Verification',
              onTap: () => Navigator.pushNamed(context, '/admin-management'),
            ),
            _DashboardCard(
              icon: Icons.analytics,
              title: 'Reports & Analytics',
              onTap: () {
                // Navigate to Reports & Analytics section
              },
            ),
            _DashboardCard(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                // Navigate to Settings
              },
            ),
            _DashboardCard(
              icon: Icons.feedback,
              title: 'Feedback',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAppFeedbackPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    Color color = Colors.deepPurple,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.deepPurple.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.deepPurple.shade700),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  late Future<List<Map<dynamic, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<Map<dynamic, dynamic>>> _fetchUsers() async {
    try {
      final DatabaseReference database = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await database.child('users').get();

      if (snapshot.exists) {
        List<Map<dynamic, dynamic>> users = [];
        (snapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              value.containsKey('email') &&
              value['role'] != 'superadmin') {
            users.add({'uid': key, ...value});
          }
        });
        return users;
      } else {
        throw 'No users found.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      throw 'Failed to fetch users. Please try again later.';
    }
  }

  Future<void> _deleteUser(String uid) async {
    bool confirmed = await _confirmAction(
      context,
      title: 'Delete User',
      content:
          'Are you sure you want to delete this user? This action cannot be undone.',
    );

    if (!confirmed) return;

    final DatabaseReference database = FirebaseDatabase.instance.ref();
    await database.child('users').child(uid).remove();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User successfully deleted.')),
    );

    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  Future<void> _changeUserRole(String uid, String currentRole) async {
    final String newRole = currentRole == 'user' ? 'admin' : 'user';

    bool confirmed = await _confirmAction(
      context,
      title: 'Change User Role',
      content: 'Are you sure you want to change the role to $newRole?',
    );

    if (!confirmed) return;

    final DatabaseReference database = FirebaseDatabase.instance.ref();
    await database.child('users').child(uid).update({
      'role': newRole,
      'isVerified': newRole == 'admin',
      'isEnabled': newRole == 'admin',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User role successfully changed to $newRole.')),
    );

    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  Future<bool> _confirmAction(BuildContext context,
      {required String title, required String content}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<dynamic, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return _UserCard(
                  user: user,
                  onEditRole: () => _changeUserRole(
                      user['uid'] as String, user['role'] as String),
                  onDelete: () => _deleteUser(user['uid'] as String),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<dynamic, dynamic> user;
  final VoidCallback onEditRole;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.onEditRole,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shadowColor: Colors.deepPurple.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.person, color: Colors.deepPurple),
        title: Text(
          user['email'] as String,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
        ),
        subtitle: Text(
          'Role: ${user['role']}',
          style: TextStyle(color: Colors.deepPurple.shade500),
        ),
        trailing: Wrap(
          spacing: 12,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: onEditRole,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
