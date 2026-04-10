import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/course.dart';
import '../../models/recordings.dart';

class IsarService {
  late final Isar isar;

  IsarService() {
    init();
  }

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      directory: dir.path,
      [CourseSchema, RecordingSchema],
    );
  }
}