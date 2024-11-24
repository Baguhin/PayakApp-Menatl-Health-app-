// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [
    {"text": "Hi! How are you feeling today? 😊", "sender": "bot"},
    {
      "text":
          "I'm here to help you with any mental health concerns or just to chat.",
      "sender": "bot"
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text.trim();
      _addMessage(userMessage, "user");
      _controller.clear();
      _scrollToBottom();

      setState(() {
        _isLoading = true;
      });

      _getChatbotResponse(userMessage);
    }
  }

  void _addMessage(String messageText, String sender) {
    setState(() {
      _messages.add({"text": messageText, "sender": sender});
      _scrollToBottom();
    });
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

  Future<void> _getChatbotResponse(String userMessage) async {
    const String apiUrl = 'http://192.168.43.161:8000/chatbot/response/';
    _addMessage("Thinking...", "bot");
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': userMessage}),
      );

      setState(() {
        _messages.removeLast();
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botResponse =
            data['response'] ?? "Sorry, I didn't understand that.";
        _addMessage(botResponse, "bot");
      } else {
        _addMessage("Oops! Something went wrong. Try again later.", "bot");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching chatbot response: $e");
      }
      _addMessage(
          "Error connecting to the server. Please try again later.", "bot");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7FF),
      appBar: AppBar(
        title: Text("Chatbot", style: GoogleFonts.poppins(fontSize: 24)),
        backgroundColor: const Color(0xFF007BFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isBotMessage = message["sender"] == "bot";
                  return Row(
                    mainAxisAlignment: isBotMessage
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (isBotMessage)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                                'assets/bot_avatar.png'), // Custom bot avatar
                          ),
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 16),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isBotMessage
                                ? const Color(0xFFE3F2FD)
                                : const Color(0xFF007BFF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            message["text"]!,
                            style: TextStyle(
                              color: isBotMessage ? Colors.black : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      if (!isBotMessage)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user.jpg'),
                            radius: 20,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    child: Lottie.asset('assets/loading/thinking.json'),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      onSubmitted: (_) {
                        _sendMessage();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF007BFF)),
                    onPressed: () {
                      _sendMessage();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
