import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResponseProvider extends ChangeNotifier {
  late GenerativeModel _model;

  ResponseProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    //final apiKey = dotenv.env['API_KEY'];
    const apiKey = "AIzaSyAi56lRfOVKIcA5Lb6hfbq11O6LfqLyCyE";

    if (apiKey.isEmpty) {
      throw Exception('API_KEY is empty');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<void> sendPcTypeRequest(String pcType) async {
    if (pcType.isEmpty) return;

    final content = [
      Content.text(
          'I want to build a $pcType PC. Provide me recommendations and details.')
    ];

    try {
      final response = await _model.generateContent(content);

      print('Response: ${response.text}');
      // Handle the JSON response as needed
    } catch (e) {
      print("Error: $e");
    }
  }
}
