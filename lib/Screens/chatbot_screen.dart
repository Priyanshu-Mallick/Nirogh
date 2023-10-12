import 'package:flutter/material.dart';
import '../Widgets/bottom_navigation.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int _selectedIndex = 3; // Set the default selected index
  List<String> _messages = []; // List to store the chat messages
  TextEditingController _messageController = TextEditingController(); // Controller for the message input

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[300],
        title: const Text('Chatbot Screen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = _messages[index].startsWith('User:');
                return _buildMessageBubble(_messages[index], screenWidth, isUserMessage);
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Adjust padding based on screen width
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.cyan,
                    size: screenWidth * 0.1, // Adjust icon size based on screen width
                  ),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: _selectedIndex),
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('User: $message');
      });

      _simulateChatbotResponse();

      _messageController.clear();
    }
  }

  void _simulateChatbotResponse() {
    String botResponse = 'Bot: Thank you for your message!';

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(botResponse);
      });
    });
  }

  Widget _buildMessageBubble(String message, double screenWidth, bool isSender) {
    double bubbleWidth = 0.7 * screenWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: bubbleWidth,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSender ? Colors.cyan : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: isSender ? const Radius.circular(15) : Radius.circular(0),
              topRight: const Radius.circular(15),
              bottomLeft: const Radius.circular(15),
              bottomRight: isSender ? Radius.circular(0) : const Radius.circular(15),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: screenWidth * 0.04), // Adjust font size based on screen width
          ),
        ),
      ),
    );
  }
}
