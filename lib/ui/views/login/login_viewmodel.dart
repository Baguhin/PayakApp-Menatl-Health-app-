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

  get isLoading => null;
  set rememberPassword(bool value) {
    _rememberPassword = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    if (_email.isEmpty || _password.isEmpty) {
      _showErrorDialog('Email and password cannot be empty.');
      return;
    }

    setBusy(true);
    try {
      // Super Admin Bypass
      if (_email == _defaultSuperAdminEmail &&
          _password == _defaultSuperAdminPassword) {
        await _redirectToSuperAdmin();
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      User? user = userCredential.user;
      if (user == null) throw 'Authentication failed.';

      // Fetch user data in parallel
      DataSnapshot snapshot =
          await _database.child('users').child(user.uid).get();

      if (!snapshot.exists) throw 'User data not found in the database.';

      final userData = Map<String, dynamic>.from(snapshot.value as Map);
      String role = userData['role'] ?? '';
      bool isVerified = userData['isVerified'] ?? false;
      bool isEnabled = userData['isEnabled'] ?? false; // Default false

      // Role Handling
      if (role == 'admin') {
        if (!isEnabled) {
          _showErrorDialog(
              'Your account is disabled. Please wait for approval.');
        } else if (!isVerified) {
          _showErrorDialog('Your account is not yet verified.');
        } else {
          _redirectToAdmin();
        }
      } else if (role == 'user') {
        _redirectToUser();
      } else {
        throw 'Unexpected role detected.';
      }

      if (_rememberPassword) {
        await _saveCredentials();
      } else {
        await _clearCredentials();
      }
    } catch (e) {
      _showErrorDialog('Login failed: ${e.toString()}');
    } finally {
      setBusy(false);
    }
  }

  Future<void> _redirectToSuperAdmin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _defaultSuperAdminEmail,
        password: _defaultSuperAdminPassword,
      );

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
    notifyListeners();
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setBool('rememberPassword', _rememberPassword);
  }

  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('rememberPassword', false);
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

  void logout() async {
    await _auth.signOut();
    _clearCredentials();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              const HomepageView(title: 'Welcome to PayakApp')),
    );
  }

  togglePasswordVisibility() {}
}
