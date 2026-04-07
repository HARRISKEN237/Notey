
import 'package:isar/isar.dart';

part '../data/models/recording.g.dart';

@collection
class Recording {
  Id id = Isar.autoIncrement;
  late String title;
  String? audioFilePath;
  String? transcript;
  String? summary;
  int? duration;
  late DateTime createdAt;
  DateTime? updatedAt;

  // Indexes for faster queries
  @Index()
  late DateTime recordedAt;
  @Index()
  late int courseId;

  bool isSynced = false;
  String? supabaseId;

  final course = IsarLink<Course>();
}