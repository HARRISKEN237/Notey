import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  // OpenAI (Whisper)
  static const String openAIBaseUrl = 'https://api.openai.com/v1';
  static const String whisperEndpoint = '$openAIBaseUrl/audio/transcriptions';
  static const String whisperModel = 'whisper-1';
  static String get openAIKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  // Anthropic (Claude)
  static const String anthropicBaseUrl = 'https://api.anthropic.com/v1';
  static const String claudeEndpoint = '$anthropicBaseUrl/messages';
  static const String claudeVersion = '2023-06-01';
  static const String claudeModel = 'claude-3-sonnet-20240229';
  static String get anthropicKey => dotenv.env['ANTHROPIC_API_KEY'] ?? '';

  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}