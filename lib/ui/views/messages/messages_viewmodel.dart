import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'message_model.dart';

class MessagesViewModel extends BaseViewModel {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');

  List<Message> messages = [];
  Map<String, String> userNames = {};

  MessagesViewModel() {
    _loadMessages();
    _loadUserNames();
  }

  void _loadUserNames() {
    _usersRef.onValue.listen((event) {
      final userMap = event.snapshot.value as Map<dynamic, dynamic>?;

      if (userMap != null) {
        userMap.forEach((key, value) {
          if (key is String && value is Map<dynamic, dynamic>) {
            // Safeguard for null or missing username field
            if (value['displayName'] != null &&
                value['displayName'] is String) {
              userNames[key] = value['displayName'] as String;
            }
          }
        });
      }
    }, onError: (error) {
      if (kDebugMode) {
        print('Error loading usernames: $error');
      }
    });
  }

  void _loadMessages() {
    _messagesRef.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        try {
          final messageMap =
              data.map((key, value) => MapEntry(key as String, value));
          final message = Message.fromJson(messageMap, event.snapshot.key!);
          messages.add(message);
          notifyListeners();
        } catch (e) {
          if (kDebugMode) {
            print('Error processing message: $e');
          }
        }
      }
    }, onError: (error) {
      if (kDebugMode) {
        print('Error loading messages: $error');
      }
    });
  }

  Future<void> sendMessage(String senderId, String text) async {
    try {
      final senderName = userNames[senderId] ?? 'Unknown';
      final newMessage = Message(
        senderId: senderId,
        senderName: senderName,
        text: text,
        timestamp: DateTime.now(),
      );

      await _messagesRef.push().set(newMessage.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  void dispose() {
    _messagesRef.onChildAdded.drain();
    _usersRef.onValue.drain();
    super.dispose();
  }
}
