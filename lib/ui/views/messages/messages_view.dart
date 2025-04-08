// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/messages/message_model.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final scrollController = ScrollController();

    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(Icons.healing, color: Colors.teal, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Healing Together',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${viewModel.userNames.length} members',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline, color: Colors.white),
            onPressed: () {
              _showMembers(context, viewModel);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showGuidelines(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images21/calm3.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.grey.withOpacity(0.9),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          children: [
            _buildSupportBanner(context),
            Expanded(
              child: viewModel.messages.isEmpty
                  ? _buildEmptyChat(context)
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: viewModel.messages.length,
                      itemBuilder: (context, index) {
                        final message = viewModel.messages[index];
                        String username =
                            viewModel.userNames[message.senderId] ??
                                message.senderId;

                        // Check if we should show date separator
                        bool showDateSeparator = false;
                        if (index == 0) {
                          showDateSeparator = true;
                        } else {
                          final prevMessage = viewModel.messages[index - 1];
                          final prevDate = DateTime(
                            prevMessage.timestamp.year,
                            prevMessage.timestamp.month,
                            prevMessage.timestamp.day,
                          );
                          final currentDate = DateTime(
                            message.timestamp.year,
                            message.timestamp.month,
                            message.timestamp.day,
                          );

                          if (prevDate != currentDate) {
                            showDateSeparator = true;
                          }
                        }

                        return Column(
                          children: [
                            if (showDateSeparator)
                              _buildDateSeparator(message.timestamp),
                            _buildMessageCard(message, username, viewModel),
                          ],
                        );
                      },
                    ),
            ),
            _buildTypingIndicator(viewModel),
            _buildMessageInput(
                messageController, viewModel, scrollController, context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.teal.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Be the first to share your thoughts',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is a safe space for everyone',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.support, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                children: const [
                  TextSpan(
                    text: 'Need immediate help? ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Call our support line at 09301527242',
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.blue.shade700, size: 20),
            onPressed: () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: '18002738255');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                // Show error message if unable to launch dialer
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not launch phone dialer'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMMM d, yyyy').format(timestamp);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade400)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              dateText,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(MessagesViewModel viewModel) {
    // Replace with actual typing detection logic
    bool someoneIsTyping = false;
    String typingUsername = "Sarah";

    if (!someoneIsTyping) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  '$typingUsername is typing',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTypingDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDots() {
    return Row(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  void _showGuidelines(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.rule_folder, color: Colors.teal),
              SizedBox(width: 10),
              Text('Community Guidelines'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGuidelineItem(
                  context,
                  icon: Icons.favorite,
                  title: 'Be kind and respectful',
                  description:
                      'Treat others with compassion and understanding, as everyone is fighting their own battles.',
                ),
                const SizedBox(height: 12),
                _buildGuidelineItem(
                  context,
                  icon: Icons.block,
                  title: 'No hate speech or bullying',
                  description:
                      'Discriminatory language, harassment, or bullying will not be tolerated.',
                ),
                const SizedBox(height: 12),
                _buildGuidelineItem(
                  context,
                  icon: Icons.lock,
                  title: 'Protect your privacy',
                  description:
                      'Do not share personal identifying information like full name, address, or phone number.',
                ),
                const SizedBox(height: 12),
                _buildGuidelineItem(
                  context,
                  icon: Icons.medical_services,
                  title: 'Seek professional help when needed',
                  description:
                      'This forum is for peer support only and does not replace professional mental health services.',
                ),
                const SizedBox(height: 12),
                _buildGuidelineItem(
                  context,
                  icon: Icons.sentiment_satisfied_alt,
                  title: 'Enjoy the community',
                  description:
                      'This is a safe space for healing, growth, and connection.',
                ),
              ],
            ),
          ),
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

  void _showMembers(BuildContext context, MessagesViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Group Members (${viewModel.userNames.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.userNames.length,
                  itemBuilder: (context, index) {
                    final userId = viewModel.userNames.keys.elementAt(index);
                    final username = viewModel.userNames[userId]!;
                    final isCurrentUser =
                        userId == FirebaseAuth.instance.currentUser?.uid;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getAvatarColor(username),
                        child: Text(
                          username[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(username),
                      trailing: isCurrentUser
                          ? const Chip(
                              label: Text('You'),
                              backgroundColor: Colors.teal,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGuidelineItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(
    TextEditingController messageController,
    MessagesViewModel viewModel,
    ScrollController scrollController,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mood, color: Colors.teal),
            onPressed: () {
              // Implement emoji picker
            },
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              String currentUserId =
                  FirebaseAuth.instance.currentUser?.uid ?? '';
              if (currentUserId.isNotEmpty &&
                  messageController.text.trim().isNotEmpty) {
                // Filter message for profanity before sending
                String filteredMessage =
                    _filterProfanity(messageController.text);

                viewModel.sendMessage(currentUserId, filteredMessage);
                messageController.clear();

                // Scroll to the bottom after sending a message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                // Request focus back on the text field
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.4),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _filterProfanity(String text) {
    // List of words to filter
    final List<String> profanityList = [
      'fuck', 'shit', 'ass', 'bitch', 'damn', 'hell', 'crap',
      'piss', 'dick', 'pussy', 'cock', 'whore', 'slut', 'bastard',
      'asshole', 'motherfucker', 'bullshit', 'cunt', 'goddamn',
      // Add more words as needed
    ];

    String filteredText = text;

    for (String word in profanityList) {
      // Create regex for whole word match with word boundaries
      RegExp regex = RegExp(
        r'\b' + word + r'\b',
        caseSensitive: false,
      );

      // Replace word with asterisks of same length
      filteredText = filteredText.replaceAllMapped(regex, (match) {
        return '*' * match.group(0)!.length;
      });
    }

    return filteredText;
  }

  Widget _buildMessageCard(
      Message message, String username, MessagesViewModel viewModel) {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    bool isCurrentUser = message.senderId == currentUserId;

    // Check if message is part of a sequence (same sender)
    int messageIndex = viewModel.messages.indexOf(message);
    bool isSequence = false;

    if (messageIndex > 0) {
      Message previousMessage = viewModel.messages[messageIndex - 1];
      isSequence = previousMessage.senderId == message.senderId &&
          message.timestamp.difference(previousMessage.timestamp).inMinutes < 5;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: isSequence ? 2 : 8,
        bottom: 2,
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isSequence)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: isCurrentUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    CircleAvatar(
                      backgroundColor: _getAvatarColor(username),
                      radius: 12,
                      child: Text(
                        username[0].toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  const SizedBox(width: 6),
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isCurrentUser && isSequence) const SizedBox(width: 24),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCurrentUser
                          ? [Colors.teal.shade100, Colors.teal.shade300]
                          : [Colors.grey.shade100, Colors.grey.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isCurrentUser ? 18 : 0),
                      bottomRight: Radius.circular(isCurrentUser ? 0 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessageContent(message.text),
                      if (isSequence)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _formatTimestamp(message.timestamp),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isCurrentUser
                                      ? Colors.teal.shade800.withOpacity(0.7)
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(String text) {
    // Check if message contains emojis
    bool containsEmojis = RegExp(
            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
        .hasMatch(text);

    // If message is just emojis, display them larger
    if (containsEmojis && text.length <= 5) {
      return Text(
        text,
        style: const TextStyle(fontSize: 26),
      );
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 16),
    );
  }

  Color _getAvatarColor(String username) {
    // Generate consistent color based on username
    final colors = [
      Colors.red.shade600,
      Colors.pink.shade600,
      Colors.purple.shade600,
      Colors.deepPurple.shade600,
      Colors.indigo.shade600,
      Colors.blue.shade600,
      Colors.lightBlue.shade600,
      Colors.cyan.shade600,
      Colors.teal.shade600,
      Colors.green.shade600,
      Colors.lightGreen.shade600,
      Colors.lime.shade600,
      Colors.orange.shade600,
      Colors.deepOrange.shade600,
    ];

    int hashCode = username.hashCode.abs();
    return colors[hashCode % colors.length];
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24 && messageDate == today) {
      return '${difference.inHours}h';
    } else if (messageDate == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(timestamp)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  @override
  MessagesViewModel viewModelBuilder(BuildContext context) =>
      MessagesViewModel();
}
