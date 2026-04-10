import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // App Strings
  static const String appName = 'Notey';
  static const String appVersion = '1.0.0';

  // Folders and Paths
  static const String recordingsPath = 'recordings';
  static const String transcriptionsPath = 'transcriptions';
  static const String summariesPath = 'summaries';

  // UI Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFB00020);

  // Default Course Colors
  static const List<Color> courseColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  // AI Prompt Templates
  static const String summarizationPrompt = '''You are an expert academic assistant. Summarize the following lecture transcript into structured, student-friendly notes.
Use headings, bullet points, and highlight key concepts and definitions.''';
}
