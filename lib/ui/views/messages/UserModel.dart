// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String profileImageUrl;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.profileImageUrl,
    required String userId,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return UserModel(
      uid: doc.id, // Use document ID as UID
      displayName: data?['displayName'] ?? 'Unknown User',
      profileImageUrl: data?['profileImageUrl'] ?? 'assets/default_profile.png',
      userId: '',
    );
  }

  get userId => null;

  // Method to generate a chat ID
  String generateChatId() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return [currentUserId, uid].join('_'); // Combine UIDs for a unique chat ID
  }
}
