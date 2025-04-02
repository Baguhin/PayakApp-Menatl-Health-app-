import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tangullo/data/Journalizing.dart';

class FirestoreService {
  final CollectionReference journalCollection =
      FirebaseFirestore.instance.collection('journals');

  Future<void> createJournalEntry(JournalEntry entry) async {
    try {
      await journalCollection.add(entry.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error creating journal entry: $e');
      }
    }
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    try {
      await journalCollection.doc(entry.id).update(entry.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating journal entry: $e');
      }
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    try {
      await journalCollection.doc(id).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting journal entry: $e');
      }
    }
  }

  Stream<List<JournalEntry>> getJournalEntries() {
    return journalCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return JournalEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      rethrow;
    }
  }

  Future<void> createUser(String uid, String role,
      {bool isVerified = false}) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'role': role,
        'isVerified': isVerified,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
    }
  }

  signInwithGoogle() {}

  getUser() {}

  signInWithEmailAndPassword(
      {required String email, required String password}) {}

  signOutFromGoogle() {}
}
