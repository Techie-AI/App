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

    print('Initializing model with API key: $apiKey');

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    print('Model initialized successfully');
  }

  Future<void> sendPcTypeRequest(String pcType) async {
    if (pcType.isEmpty) return;

    print('Sending request for PC type: $pcType');

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
