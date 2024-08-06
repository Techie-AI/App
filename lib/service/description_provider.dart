import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DescriptionProvider extends ChangeNotifier {
  late GenerativeModel _model;

  DescriptionProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    final apiKey = dotenv.env['API_KEY'];

    if (apiKey!.isEmpty) {
      throw Exception('API_KEY is empty');
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 64,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'application/json',
      ),
    );
  }

  Future<String> getComponentDescription(String name, String price) async {
    if (name.isEmpty || price.isEmpty) return '';

    final content = [
      Content.text(
          'give the description of this component with specs In detail\n\n'
          '{ "name": "$name", "price": "$price" }')
    ];

    try {
      final response = await _model.generateContent(content);

      String? output = response.text;

      if (output == null || output.isEmpty) {
        print("No response from API");
        return 'No description available.';
      }

      return output;
    } catch (e) {
      print("Error: $e");
      return 'An error occurred while fetching the description.';
    }
  }
}
