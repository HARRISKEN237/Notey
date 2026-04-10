import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SummarizationService {
  Future<String> generateSummary(String transcript) async {
    final apiKey = dotenv.env['ANTHROPIC_API_KEY'];
    if (apiKey == null) throw Exception('ANTHROPIC_API_KEY not found in .env');

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': 'claude-3-sonnet-20240229', // or the version you prefer
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': '''You are an expert academic assistant. Summarize the following lecture transcript into structured, student-friendly notes.
Use headings, bullet points, and highlight key concepts and definitions.

Transcript:
$transcript'''
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'][0]['text'] as String;
    } else {
      final error = jsonDecode(response.body);
      throw Exception('Summarization failed: ${error['error']['message'] ?? response.body}');
    }
  }
}