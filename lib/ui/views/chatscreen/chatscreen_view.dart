import 'package:flutter/material.dart';

class ChatscreenView extends StatefulWidget {
  final String chatId;
  final String userName;

  const ChatscreenView({
    required this.chatId,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatscreenViewState createState() => _ChatscreenViewState();
}

class _ChatscreenViewState extends State<ChatscreenView> {
  @override
  Widget build(BuildContext context) {
    return Container(); // Empty widget for now
  }
}
