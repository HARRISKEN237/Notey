import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/transcription_service.dart';
import '../core/services/summarization_service.dart';
import '../core/services/noise_cancellation_service.dart';
import '../repositories/note_repository.dart';
import '../models/recordings.dart';
import '../core/services/isar_service.dart';

enum ProcessingStatus { idle, cleaning, transcribing, summarizing, saving, completed, error }

class ProcessingState {
  final ProcessingStatus status;
  final String? message;
  final String? error;

  ProcessingState({this.status = ProcessingStatus.idle, this.message, this.error});

  ProcessingState copyWith({ProcessingStatus? status, String? message, String? error}) {
    return ProcessingState(
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}

final recordingProcessingProvider = StateNotifierProvider<RecordingProcessingNotifier, ProcessingState>((ref) {
  return RecordingProcessingNotifier(
    TranscriptionService(),
    SummarizationService(),
    NoiseCancellationService(),
    NoteRepository(IsarService()), // Simplified for this example
  );
});

class RecordingProcessingNotifier extends StateNotifier<ProcessingState> {
  final TranscriptionService _transcriptionService;
  final SummarizationService _summarizationService;
  final NoiseCancellationService _noiseService;
  final NoteRepository _repository;

  RecordingProcessingNotifier(
    this._transcriptionService,
    this._summarizationService,
    this._noiseService,
    this._repository,
  ) : super(ProcessingState());

  Future<void> processRecording(String rawPath, String title, int courseId) async {
    try {
      // 1. Noise Cancellation
      state = state.copyWith(status: ProcessingStatus.cleaning, message: 'Removing background noise...');
      final cleanPath = await _noiseService.processAudio(rawPath);

      // 2. Transcription
      state = state.copyWith(status: ProcessingStatus.transcribing, message: 'Converting speech to text...');
      final transcript = await _transcriptionService.transcribeAudio(cleanPath);

      // 3. Summarization
      state = state.copyWith(status: ProcessingStatus.summarizing, message: 'Generating AI summary...');
      final summary = await _summarizationService.generateSummary(transcript);

      // 4. Save to DB
      state = state.copyWith(status: ProcessingStatus.saving, message: 'Saving your notes...');
      final note = Recording()
        ..title = title
        ..courseId = courseId
        ..audioFilePath = cleanPath
        ..transcript = transcript
        ..summary = summary
        ..createdAt = DateTime.now()
        ..recordedAt = DateTime.now();

      await _repository.saveNote(note);

      state = state.copyWith(status: ProcessingStatus.completed, message: 'All done!');
    } catch (e) {
      state = state.copyWith(status: ProcessingStatus.error, error: e.toString());
    }
  }
}