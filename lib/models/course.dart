import 'package:isar/isar.dart';
import 'recordings.dart';

part 'course.g.dart';

@collection
class Course {
  Id id = Isar.autoIncrement;
  late String name;
  String? instructor;
  String? color;
  late DateTime createdAt;
  DateTime? updatedAt;


  bool isSynced = false;

  // The Supabase UUID for this course, once it's been uploaded.
  String? supabaseId;

  // --- One-to-many relationship: a Course has many Recordings ---
  final recordings = IsarLinks<Recording>();
}