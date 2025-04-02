// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignupViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  bool _showPassword = false;
  String _username = '';
  String _email = '';
  String _password = '';
  final String _role = 'user'; // Default role
  final bool _isVerified = false;

  String get username => _username;
  set username(String value) {
    _username = value;
    notifyListeners();
  }

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

  bool get showPassword => _showPassword;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  Future<void> createUser(String uid) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _database.child('users').child(uid).set({
        'displayName': _username,
        'email': _email,
        'role': _role,
        'isVerified': _isVerified,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      if (kDebugMode) print("Error saving user data: $e");
    } finally {
      stopwatch.stop();
      if (kDebugMode) {
        print("User data write time: ${stopwatch.elapsedMilliseconds} ms");
      }
    }
  }

  Future<void> createAdminUser(String uid) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _database.child('users').child(uid).set({
        'displayName': _username,
        'email': _email,
        'role': 'admin',
        'isVerified': false,
        'isEnabled': false,
        'timestamp': DateTime.now().toIso8601String(),
        'isAdmin': true,
      });

      await _database.child('pending_admin_requests').child(uid).set({
        'displayName': _username,
        'email': _email,
        'uid': uid,
      });
    } catch (e) {
      if (kDebugMode) print("Error saving admin data: $e");
    } finally {
      stopwatch.stop();
      if (kDebugMode) {
        print("Admin data write time: ${stopwatch.elapsedMilliseconds} ms");
      }
    }
  }

  Future<void> signup(BuildContext context) async {
    setBusy(true);
    final stopwatch = Stopwatch()..start();

    try {
      if (_email.isEmpty || _password.isEmpty || _username.isEmpty) {
        throw 'Email, password, and username cannot be empty.';
      }

      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_email)) {
        throw 'Please enter a valid email address.';
      }

      if (_email == 'johnchrisbaguhin@gmail.com') {
        throw 'Cannot create an account with this email. Reserved for Super Admin.';
      }

      print("Creating Firebase user...");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      stopwatch.stop();
      print(
          "Firebase Authentication time: ${stopwatch.elapsedMilliseconds} ms");

      User? user = userCredential.user;
      if (user != null) {
        await user.updateProfile(displayName: _username);
        await user.reload();

        if (_email.contains('Bisu')) {
          print("Admin account detected. Writing admin data...");
          await createAdminUser(user.uid);
          await _showSuccessDialog(context,
              'Your account has been created as an admin. Please wait for approval.');
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          print("User account detected. Writing user data...");
          await createUser(user.uid);
          await _showSuccessDialog(
              context, 'Your account has been created successfully.');
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error during signup: $e');
      _showErrorDialog(context, e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> _showSuccessDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Signup Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
