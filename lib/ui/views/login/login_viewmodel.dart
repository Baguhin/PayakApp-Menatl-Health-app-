// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tangullo/ui/views/admin/admindashboard.dart';
import 'package:tangullo/ui/views/admin/superadmin.dart';
import 'package:tangullo/ui/views/navigation/homepage_view.dart';

class LoginViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final BuildContext context;

  final String _defaultSuperAdminEmail = 'johnchrisbaguhin@gmail.com';
  final String _defaultSuperAdminPassword = '123456';

  LoginViewModel(this.context) {
    _loadCredentials();
  }

  String _email = '';
  String _password = '';
  bool _rememberPassword = false;

  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool get rememberPassword => _rememberPassword;
  set rememberPassword(bool value) {
    _rememberPassword = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setBusy(true);

    try {
      if (_email.isEmpty || _password.isEmpty) {
        throw 'Email and password cannot be empty.';
      }

      // Check for Super Admin credentials
      if (_email == _defaultSuperAdminEmail &&
          _password == _defaultSuperAdminPassword) {
        _redirectToSuperAdmin();
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      User? user = userCredential.user;
      if (user == null) throw 'Authentication failed.';

      // Retrieve user data from Realtime Database
      DataSnapshot snapshot =
          await _database.child('users').child(user.uid).get();
      if (!snapshot.exists) throw 'User data not found in the database.';

      final userData = snapshot.value as Map;
      String role = userData['role'];
      bool isVerified = userData['isVerified'];
      bool isEnabled = userData['isEnabled'] ?? false; // Default to false

      // Only check 'isEnabled' for admin users
      if (role == 'admin' && !isEnabled) {
        _showErrorDialog('Your account is disabled. Please wait for approval.');
        return;
      }

      if (role == 'admin') {
        isVerified
            ? _redirectToAdmin()
            : _showErrorDialog('Your account is not yet verified.');
      } else if (role == 'user') {
        _redirectToUser();
      } else {
        throw 'Unexpected role detected.';
      }

      if (_rememberPassword) {
        _saveCredentials();
      } else {
        _clearCredentials();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setBusy(false);
    }
  }

  void _redirectToSuperAdmin() async {
    // Check if super admin email exists in Firebase
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _defaultSuperAdminEmail,
        password: _defaultSuperAdminPassword,
      );

      // If sign-in is successful, proceed with redirection
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SuperAdminDashboardView(),
        ));
        _showSuccessMessage('Login successful! Welcome Super Admin.');
      }
    } catch (e) {
      _showErrorDialog('Failed to log in as Super Admin: ${e.toString()}');
    }
  }

  void _redirectToAdmin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const AdminDashboardView(),
    ));
    _showSuccessMessage('Login successful! Welcome Admin.');
  }

  void _redirectToUser() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const HomepageView(title: 'Welcome to PayakApp'),
    ));
    _showSuccessMessage('Login successful! Welcome User.');
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('email') ?? '';
    _password = prefs.getString('password') ?? '';
    _rememberPassword = prefs.getBool('rememberPassword') ?? false;
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email);
    prefs.setString('password', _password);
    prefs.setBool('rememberPassword', _rememberPassword);
  }

  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.setBool('rememberPassword', false);
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  logout() {}
}
