// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  String? id;
  final String title;
  final String content;
  final DateTime date;

  JournalEntry(
      {this.id,
      required this.title,
      required this.content,
      required this.date});

  // Convert a JournalEntry object into a map.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date,
    };
  }

  // Create a JournalEntry from a map.
  factory JournalEntry.fromMap(Map<String, dynamic> map, String id) {
    return JournalEntry(
      id: id,
      title: map['title'],
      content: map['content'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
