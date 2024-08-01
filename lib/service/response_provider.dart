import 'dart:convert';
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

  Future<Map<String, dynamic>> sendPcTypeRequest(
      String pcType, String budget) async {
    if (pcType.isEmpty || budget.isEmpty) return {};

    final content = [
      Content.text(
          'Hey, I want your advice on PC building. I want a $pcType but I have a budget of $budget INR. Can you give me multiple options for every component with prices and links to buy from, in JSON format? Give 3 options for each. JSON Example: {"components": {"cpu": {}, "motherboard": {}, ...}}')
    ];

    try {
      final response = await _model.generateContent(content);

      String? output = response.text;

      if (output == null || output.isEmpty) {
        print("No response from API");
        return {};
      }

      final Map<String, dynamic> result = jsonDecode(output);

      // Check the structure of the result and ensure it matches the expected format
      if (result.containsKey('components') && result['components'] is Map) {
        return result;
      } else {
        print("Unexpected JSON structure");
        return {};
      }
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }
}
