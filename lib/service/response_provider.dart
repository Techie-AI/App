import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResponseProvider extends ChangeNotifier {
  late GenerativeModel _model;

  ResponseProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('No API_KEY found in .env file');
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

      if (response != null) {
        print('Response: ${response.text}');
        // Handle the JSON response as needed
      } else {
        print("Error: No response from API");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
