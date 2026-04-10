import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recordings.dart';
import '../core/services/isar_service.dart';

class NoteRepository {
  final IsarService _isarService;
  final SupabaseClient _supabase = Supabase.instance.client;

  NoteRepository(this._isarService);

  // Get all notes from local DB (Sync handles cloud data)
  Stream<List<Recording>> watchNotes() {
    return _isarService.isar.recordings.where().sortByCreatedAtDesc().watch(fireImmediately: true);
  }

  Future<void> saveNote(Recording note) async {
    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.recordings.put(note);
    });
    
    // Try to sync to cloud if user is logged in
    if (_supabase.auth.currentUser != null) {
      _syncToCloud(note);
    }
  }

  Future<void> _syncToCloud(Recording note) async {
    try {
      final data = {
        'title': note.title,
        'transcript': note.transcript,
        'summary': note.summary,
        'user_id': _supabase.auth.currentUser!.id,
        'created_at': note.createdAt.toIso8601String(),
      };

      if (note.supabaseId != null) {
        await _supabase.from('notes').update(data).eq('id', note.supabaseId!);
      } else {
        final response = await _supabase.from('notes').insert(data).select().single();
        
        // Update local note with Supabase ID
        await _isarService.isar.writeTxn(() async {
          note.supabaseId = response['id'];
          note.isSynced = true;
          await _isarService.isar.recordings.put(note);
        });
      }
    } catch (e) {
      print('Cloud sync failed: $e');
      // Note remains in local Isar with isSynced = false
    }
  }
}