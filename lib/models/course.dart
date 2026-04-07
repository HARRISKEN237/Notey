// lib/models/course.dart
import 'package:isar/isar.dart';

part '../data/models/course.g.dart';

@collection
class Course {
  Id id = Isar.autoIncrement; // Auto-incrementing local primary key
  late String name;
  String? instructor;
  String? color;
  late DateTime createdAt;
  DateTime? updatedAt;

  // Custom flag to track if this course has been synced with Supabase
  bool isSynced = false;

  // The Supabase UUID for this course, once it's been uploaded.
  String? supabaseId;

  // --- One-to-many relationship: a Course has many Recordings ---
  final recordings = IsarLinks<Recording>();
}