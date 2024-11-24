import 'package:flutter/material.dart';

import 'package:tangullo/ui/views/chatbot/model.dart'; // Assuming you have a ChatModel class here

class ChatItemCard extends StatelessWidget {
  final ChatModel chatItem;
  final Color botChatBubbleColor;
  final Color userChatBubbleColor;
  final Color botChatBubbleTextColor;
  final Color userChatBubbleTextColor;
  final VoidCallback? onTap;

  const ChatItemCard({
    super.key,
    required this.chatItem,
    required this.botChatBubbleColor,
    required this.userChatBubbleColor,
    required this.botChatBubbleTextColor,
    required this.userChatBubbleTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isUserMessage = chatItem.chat == 0; // Assuming 0 is user and 1 is bot

    // Chat Bubble Gradient and Shadow for better visual impact
    final gradientColor =
        isUserMessage ? userChatBubbleColor : botChatBubbleColor;
    final textColor =
        isUserMessage ? userChatBubbleTextColor : botChatBubbleTextColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        margin: const EdgeInsets.symmetric(vertical: 10), // Adjusted margin
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientColor.withOpacity(0.9), // Subtle gradient effect
              gradientColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24), // More rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.8, // Adjusted for better content fitting
        ),
        child: Column(
          crossAxisAlignment:
              isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUserMessage) ...[
              // Bot Avatar/Icon
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: botChatBubbleColor.withOpacity(0.8),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
            // Chat message text
            Text(
              chatItem.message,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600, // Slightly bolder for clarity
                letterSpacing: 0.8, // Increased letter-spacing for readability
                height: 1.4, // Adjusted line height for better spacing
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            if (chatItem.chatType == ChatType.loading) ...[
              // Add a loading spinner when chat type is loading
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ],
            if (chatItem.chatType == ChatType.error) ...[
              // Add error message if there's an issue
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Oops! Something went wrong.',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
