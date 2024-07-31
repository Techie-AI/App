import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage({required this.content, required this.isUser});
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  String pcType = ''; // Store the selected PC type

  List<ChatMessage> get messages => _messages;
  TextEditingController get controller => _controller;

  void setPcType(String type) {
    pcType = type;
    notifyListeners();
  }

  void sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    _messages.add(ChatMessage(content: userMessage, isUser: true));
    _controller.clear();
    notifyListeners();

    // Send message to the API
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT'), // Replace with your actual API endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': userMessage,
        'pcType': pcType, // Include the selected PC type in the request
      }),
    );

    if (response.statusCode == 200) {
      final botMessage = jsonDecode(response.body)['response'];
      _messages.add(ChatMessage(content: botMessage, isUser: false));
    } else {
      _messages.add(
          ChatMessage(content: "Error: Unable to get response", isUser: false));
    }
    notifyListeners();
  }
}
