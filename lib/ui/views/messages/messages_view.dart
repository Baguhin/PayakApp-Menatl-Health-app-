// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/messages/message_model.dart';
import 'messages_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesView extends StackedView<MessagesViewModel> {
  const MessagesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MessagesViewModel viewModel,
    Widget? child,
  ) {
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mental Health Forum',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showGuidelines(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = viewModel.messages[index];
                String username =
                    viewModel.userNames[message.senderId] ?? message.senderId;

                return _buildMessageCard(message, username);
              },
            ),
          ),
          _buildMessageInput(
              messageController, viewModel, scrollController, context),
        ],
      ),
    );
  }

  void _showGuidelines(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Community Guidelines'),
          content: const Text(
              '1. Be respectful and kind.\n2. No hate speech or bullying.\n3. Keep personal information private.\n4. Seek professional help if needed.\n5. Enjoy the community!'),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput(
    TextEditingController messageController,
    MessagesViewModel viewModel,
    ScrollController scrollController,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              String currentUserId =
                  FirebaseAuth.instance.currentUser?.uid ?? '';
              if (currentUserId.isNotEmpty &&
                  messageController.text.isNotEmpty) {
                viewModel.sendMessage(currentUserId, messageController.text);
                messageController.clear();

                // Scroll to the bottom after sending a message
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);

                // Request focus back on the text field
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            child: const CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 25,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Message message, String username) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    bool isCurrentUser = message.senderId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCurrentUser
                  ? [Colors.greenAccent.shade100, Colors.green.shade300]
                  : [Colors.blue.shade100, Colors.blue.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              // Removed Circle Avatar from here
              Expanded(
                child: Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              // Removed Circle Avatar from here
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes == 0) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  @override
  MessagesViewModel viewModelBuilder(BuildContext context) =>
      MessagesViewModel();
}
