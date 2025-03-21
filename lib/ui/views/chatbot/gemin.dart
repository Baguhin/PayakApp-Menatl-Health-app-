import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey =
      'AIzaSyB-UQ58hUgF5trRwnNADtYaVUkY8PtCDhY'; // Replace with your actual key

  Future<String> getResponse(String userInput) async {
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": userInput}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]['content']?['parts']?[0]['text'] ??
          "No response.";
    } else {
      return "Error: ${response.statusCode} - ${response.body}";
    }
  }
}
