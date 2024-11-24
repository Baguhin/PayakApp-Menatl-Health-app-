// ignore_for_file: body_might_complete_normally_nullable

class Message {
  final String senderId;
  final String senderName; // New field for sender's name
  final String text;
  final DateTime timestamp;

  Message(
      {required this.senderId,
      required this.senderName,
      required this.text,
      required this.timestamp});

  // Update the fromJson and toJson methods accordingly
  factory Message.fromJson(Map<String, dynamic> json, String id) {
    return Message(
      senderId: json['senderId'],
      senderName: json['senderName'], // New field
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName, // Include sender name
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static fromMap(value) {}

  Object? toMap() {}
}
