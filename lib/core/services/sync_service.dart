import 'package:isar/isar.dart';
import '../../models/course.dart';
import '../../models/recordings.dart';
import 'isar_service.dart';
import 'supabase_service.dart';

class SyncService {
  final IsarService _isarService;
  final SupabaseService _supabaseService;

  SyncService(this._isarService, this._supabaseService);

  /// Performs a full synchronization between local Isar and remote Supabase.
  Future<void> performFullSync() async {
    if (_supabaseService.userId == null) return;

    try {
      await _syncCourses();
      await _syncNotes();
    } catch (e) {
      print('Full sync failed: $e');
    }
  }

  /// Pushes local courses to Supabase.
  Future<void> _syncCourses() async {
    // 1. Push local unsynced courses
    final unsyncedCourses = await _isarService.isar.courses
        .filter()
        .isSyncedEqualTo(false)
        .findAll();

    for (var course in unsyncedCourses) {
      try {
        // Use the existing syncCourse method from SupabaseService
        final response = await _supabaseService.syncCourse(course);
        
        await _isarService.isar.writeTxn(() async {
          course.supabaseId = response['id'];
          course.isSynced = true;
          await _isarService.isar.courses.put(course);
        });
      } catch (e) {
        print('Error syncing course ${course.name}: $e');
      }
    }
  }

  /// Pushes local unsynced notes to Supabase.
  Future<void> _syncNotes() async {
    final unsyncedNotes = await _isarService.isar.recordings
        .filter()
        .isSyncedEqualTo(false)
        .findAll();

    for (var note in unsyncedNotes) {
      try {
        final response = await _supabaseService.syncNote(note);
        
        await _isarService.isar.writeTxn(() async {
          note.supabaseId = response['id'];
          note.isSynced = true;
          await _isarService.isar.recordings.put(note);
        });
      } catch (e) {
        print('Error syncing note ${note.title}: $e');
      }
    }
  }
}