import 'package:flutter/material.dart';
import 'gemin.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AdminChatbot extends StatefulWidget {
  const AdminChatbot({super.key});

  @override
  _AdminChatbotState createState() => _AdminChatbotState();
}

class _AdminChatbotState extends State<AdminChatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Welcome message
  @override
  void initState() {
    super.initState();
    // Add welcome message after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                "Hello! I'm your mental health assistant. How are you feeling today?",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  // Function to clean Gemini responses
  String _sanitizeResponse(String response) {
    return response
        .replaceAll('*', '')
        .replaceAll('%', '')
        .replaceAll('#', '')
        .replaceAll('`', '');
  }

  void _sendRequest() async {
    if (_controller.text.isEmpty) return;

    String input = _controller.text.trim();
    final userMessage = ChatMessage(
      text: input,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      String result = await GeminiService().getResponse(input.toLowerCase());
      String cleanedResult = _sanitizeResponse(result);

      setState(() {
        _messages.add(ChatMessage(
          text: cleanedResult,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "I'm sorry, I couldn't process your request. Please try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.health_and_safety, color: Colors.teal.shade700),
            ),
            const SizedBox(width: 12),
            const Text("PayakApp Chatbot"),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images21/calm4.jpg'),
            opacity: 0.05,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Date divider
            if (_messages.isNotEmpty) _buildDateDivider(),

            // Chat messages
            Expanded(child: chatBody()),

            // Typing indicator
            if (_isLoading) typingIndicator(),

            // Bottom input field
            textFieldBottomWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Today",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 0.5)),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.teal.shade700),
            const SizedBox(width: 8),
            const Flexible(child: Text("About Payakapp Companion")),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This is an AI-powered mental health assistant designed to provide support and guidance.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                "Important: This app does not replace professional mental health care. If you're experiencing a crisis, please contact emergency services or a mental health professional.",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Close", style: TextStyle(color: Colors.teal.shade700)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget chatBody() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final bool showAvatar = index == 0 ||
            (_messages[index].isUser != _messages[index - 1].isUser);

        return Column(
          children: [
            if (index > 0 && _shouldShowTimeSeparator(index))
              _buildTimeSeparator(_messages[index].timestamp),
            chatBubble(_messages[index], showAvatar),
          ],
        );
      },
    );
  }

  bool _shouldShowTimeSeparator(int index) {
    if (index == 0) return false;

    final DateTime current = _messages[index].timestamp;
    final DateTime previous = _messages[index - 1].timestamp;

    return current.difference(previous).inMinutes > 5;
  }

  Widget _buildTimeSeparator(DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        _formatTime(time),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget chatBubble(ChatMessage message, bool showAvatar) {
    final bool isUserMessage = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Bot avatar
          if (!isUserMessage && showAvatar)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.teal.shade100, width: 1),
              ),
              child:
                  Icon(Icons.psychology, color: Colors.teal.shade700, size: 20),
            ),
          if (!isUserMessage && !showAvatar)
            const SizedBox(width: 36), // Space for alignment

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUserMessage ? Colors.teal.shade700 : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isUserMessage
                      ? const Radius.circular(20)
                      : const Radius.circular(5),
                  bottomRight: !isUserMessage
                      ? const Radius.circular(20)
                      : const Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUserMessage ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),

          // User avatar
          if (isUserMessage && showAvatar)
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                color: Colors.teal.shade200,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          if (isUserMessage && !showAvatar)
            const SizedBox(width: 36), // Space for alignment
        ],
      ),
    );
  }

  Widget typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.teal.shade100, width: 1),
              ),
              child:
                  Icon(Icons.psychology, color: Colors.teal.shade700, size: 20),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildDot(0),
                  _buildDot(1),
                  _buildDot(2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.teal.shade300,
        shape: BoxShape.circle,
      ),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 300 + (index * 200)),
        curve: Curves.easeInOut,
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: const SizedBox(),
      ),
    );
  }

  Widget textFieldBottomWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quick response buttons
            Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon:
                    Icon(Icons.lightbulb_outline, color: Colors.teal.shade700),
                onPressed: () {
                  _showQuickResponses(context);
                },
              ),
            ),
            const SizedBox(width: 8),

            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Message Mind Companion...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.mic_none_rounded,
                        color: Colors.teal.shade700,
                      ),
                      onPressed: () {
                        // Voice input functionality could be added here
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal.shade500,
                    Colors.teal.shade700,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _sendRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickResponses(BuildContext context) {
    final List<String> quickResponses = [
      "I'm feeling anxious today",
      "I need some relaxation techniques",
      "How can I improve my sleep?",
      "I'm feeling sad and don't know why",
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.teal.shade700),
                  const SizedBox(width: 8),
                  Text(
                    "Quick Messages",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Select a message to send quickly:",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickResponses.map((response) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _controller.text = response;
                      _sendRequest();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.teal.shade200),
                      ),
                      child: Text(
                        response,
                        style: TextStyle(color: Colors.teal.shade700),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
