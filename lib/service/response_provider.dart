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
      Content.text('hey, i want your advice on pc building\n'
          'i want a $pcType but i have $budget budget\n\n'
          'can you give me multiple options for every component with prices\n'
          'in only JSON\n\n'
          'give 3 options for each\n\n'
          'JSON Example \n'
          '"components": {\n'
          '    "cpu": {},\n'
          '    "motherboard": {},\n'
          '    ...\n'
          '}')
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
        // Add product links
        result['components'].forEach((component, options) {
          if (options is List) {
            for (var option in options) {
              if (option is Map && option.containsKey('name')) {
                String productName = option['name'];
                option['link'] =
                    "https://www.amazon.in/s?k=${Uri.encodeComponent(productName)}";
              }
            }
          }
        });
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
