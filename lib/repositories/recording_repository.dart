import 'package:isar/isar.dart';
import '../models/recordings.dart';
import '../core/services/isar_service.dart';

class RecordingRepository {
  final IsarService _isarService;

  RecordingRepository(this._isarService);

  Stream<List<Recording>> watchRecordings() {
    return _isarService.isar.recordings.where().sortByRecordedAtDesc().watch(fireImmediately: true);
  }

  Future<void> saveRecording(Recording recording) async {
    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.recordings.put(recording);
    });
  }

  Future<void> deleteRecording(Id id) async {
    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.recordings.delete(id);
    });
  }

  Future<List<Recording>> getRecordingsForCourse(int courseId) async {
    return await _isarService.isar.recordings.where().courseIdEqualTo(courseId).findAll();
  }
}