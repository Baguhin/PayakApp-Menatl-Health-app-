import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized

  // Create the Super Admin account
  await createSuperAdmin();
}

Future<void> createSuperAdmin() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Create the Super Admin account
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: 'johnchrisbaguhin@gmail.com',
      password: '123456',
    );

    // Add the user to Firestore with relevant details
    await firestore.collection('users').doc(userCredential.user?.uid).set({
      'displayName': 'Super Admin',
      'email': 'johnchrisbaguhin@gmail.com',
      'role': 'superAdmin',
      'isVerified': true,
      'isEnabled': true,
    });

    if (kDebugMode) {
      print('Super Admin account created successfully.');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error creating Super Admin account: $e');
    }
  }
}
