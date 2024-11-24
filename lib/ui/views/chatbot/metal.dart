// ignore_for_file: unused_import, unnecessary_import, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tangullo/theme/colors.dart';
import 'package:tangullo/ui/views/Utils/colors.dart';
import 'package:tangullo/ui/views/chatbot/costant.dart';
import 'package:tangullo/ui/views/chatbot/helper.dart';
import 'package:tangullo/ui/views/chatbot/model.dart';
import 'package:tangullo/ui/views/chatbot/services.dart';

class FlutterGeminiChat extends StatefulWidget {
  FlutterGeminiChat({
    super.key,
    required this.chatContext,
    required List<ChatModel> chatList,
    required this.apiKey,
    this.hintText = "How are you feeling today?",
    this.bodyPlaceHolder = const BodyPlaceholderWidget(), // Make this constant
    this.buttonColor = primary, // Calm color
    this.errorMessage = "Oops, something went wrong. Please try again later.",
    this.botChatBubbleColor = primary, // Calming blue color
    this.userChatBubbleColor = const Color(0xFFe0e7ff), // Light lavender color
    this.botChatBubbleTextColor = Colors.white,
    this.userChatBubbleTextColor = Colors.black87,
    this.loaderWidget = const Center(
      child: CircularProgressIndicator(
        color: primary,
      ),
    ),
    this.onRecorderTap,
  }) : _chatList = List<ChatModel>.from(chatList);

  final String chatContext;
  final List<ChatModel> _chatList; // Immutable copy passed to widget
  final String apiKey;
  final String hintText;
  final Widget bodyPlaceHolder;
  final Color buttonColor;
  final String errorMessage;
  final Color botChatBubbleColor;
  final Color userChatBubbleColor;
  final Color botChatBubbleTextColor;
  final Color userChatBubbleTextColor;
  final Widget loaderWidget;
  final VoidCallback? onRecorderTap;

  @override
  _FlutterGeminiChatState createState() => _FlutterGeminiChatState();
}

class _FlutterGeminiChatState extends State<FlutterGeminiChat> {
  late List<ChatModel> chatList;
  final List<Map<String, String>> messages = [];
  final TextEditingController questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<ChatModel> st; // Declare the variable here

  @override
  void initState() {
    super.initState();
    chatList = List<ChatModel>.from(widget._chatList); // Create modifiable copy
    st = List<ChatModel>.from(chatList); // Initialize in initState
    messages.add({"text": widget.chatContext});
  }

  @override
  void dispose() {
    questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mental Health Chatbot"),
        backgroundColor: widget.buttonColor,
        elevation: 2,
        foregroundColor: Colors.white, // Set the text color to white
      ),
      backgroundColor: const Color(0xFFf1f5f8), // Soft background color
      body: Stack(
        children: [
          Positioned.fill(
            child: chatList.isEmpty ? widget.bodyPlaceHolder : chatBody(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: textFieldBottomWidget(),
          ),
        ],
      ),
    );
  }

  Padding chatBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          var chat = chatList[index];
          bool isUserMessage = chat.chat == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Align(
              alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: isUserMessage
                      ? widget.userChatBubbleColor
                      : widget.botChatBubbleColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.message,
                      style: TextStyle(
                        color: isUserMessage
                            ? widget.userChatBubbleTextColor
                            : widget.botChatBubbleTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      chat.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> showToolsDialog(BuildContext context, int index) {
    return customDialog(
      context: context,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Clipboard.setData(ClipboardData(text: chatList[index].message));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: primary,
                  duration: Duration(milliseconds: 400),
                  content: Text('Copied to Clipboard'),
                ),
              );
            },
            leading: const Icon(Icons.copy),
            title: const Text("Copy"),
          ),
          ListTile(
            onTap: () {
              setState(() {
                if (chatList.isNotEmpty) {
                  chatList.removeAt(index);
                }
              });
              Navigator.pop(context);
            },
            leading: const Icon(Icons.delete),
            title: const Text("Delete"),
          ),
          ListTile(
            onTap: () {
              setState(() {
                questionController.text = chatList[index].message;
                questionController.selection = TextSelection.fromPosition(
                    TextPosition(offset: questionController.text.length));
              });
              Navigator.pop(context);
            },
            leading: const Icon(Icons.edit),
            title: const Text("Edit"),
          ),
        ],
      ),
    );
  }

  Widget textFieldBottomWidget() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: questionController,
        builder: (context, value, child) {
          return SingleChildScrollView(
            // Wrap the TextField in a SingleChildScrollView
            scrollDirection: Axis.vertical,
            child: TextField(
              controller: questionController,
              keyboardType: TextInputType.multiline, // Allow multiline input
              maxLines: null, // Let the text wrap to the next line
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[600]),
                suffixIcon: value.text.isEmpty
                    ? null
                    : InkWell(
                        onTap: () async {
                          var question = questionController.text;
                          setState(() {
                            chatList.add(ChatModel(
                              chat: 0,
                              message: question,
                              time:
                                  "${DateTime.now().hour}:${DateTime.now().minute}",
                            ));
                            chatList.add(ChatModel(
                              chatType: ChatType.loading,
                              chat: 1,
                              message: "",
                              time: "",
                            ));
                          });

                          FocusScope.of(context).unfocus();
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }

                          messages.add(
                              {"text": "${widget.chatContext}\n$question"});
                          questionController.clear();
                          var (responseString, response) =
                              await GeminiApi.geminiChatApi(
                            messages: messages,
                            apiKey: widget.apiKey,
                          );

                          setState(() {
                            if (chatList.isNotEmpty &&
                                chatList.last.chatType == ChatType.loading) {
                              chatList.removeLast();
                            }
                            if (response.statusCode == 200) {
                              chatList.add(ChatModel(
                                chat: 1,
                                message: responseString,
                                time:
                                    "${DateTime.now().hour}:${DateTime.now().minute}",
                              ));
                            } else {
                              chatList.add(ChatModel(
                                chat: 1,
                                message: widget.errorMessage,
                                time:
                                    "${DateTime.now().hour}:${DateTime.now().minute}",
                              ));
                            }
                          });

                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: const Icon(
                          Icons.send,
                          color: primary,
                        ),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0.8,
                    color: primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0.8,
                    color: primary,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BodyPlaceholderWidget extends StatelessWidget {
  const BodyPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No chats yet. Start a conversation!",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
