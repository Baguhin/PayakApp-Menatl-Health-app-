import 'package:flutter/material.dart';
import 'gemin.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
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

  void _sendRequest() async {
    if (_controller.text.isEmpty) return;

    String input = _controller.text.trim().toLowerCase();

    setState(() {
      _messages.add(ChatMessage(text: _controller.text, isUser: true));
    });

    _controller.clear();
    _scrollToBottom();

    setState(() {
      _isLoading = true;
    });

    String result = await GeminiService().getResponse(input);

    setState(() {
      _messages.add(ChatMessage(text: result, isUser: false));
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Health AI"),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          Expanded(child: chatBody()),
          if (_isLoading) typingIndicator(),
          textFieldBottomWidget(),
        ],
      ),
    );
  }

  Widget chatBody() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return chatBubble(_messages[index]);
      },
    );
  }

  Widget chatBubble(ChatMessage message) {
    bool isUserMessage = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.teal.shade700 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            message.text,
            style: TextStyle(
              color: isUserMessage ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget typingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: CircularProgressIndicator(color: Colors.teal.shade700),
      ),
    );
  }

  Widget textFieldBottomWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Type your message...",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.teal.shade700,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendRequest,
            ),
          ),
        ],
      ),
    );
  }
}
