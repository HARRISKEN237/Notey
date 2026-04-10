import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class AudioRecordingService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _currentPath;

  Future<bool> isRecording() => _audioRecorder.isRecording();
  Future<bool> isPaused() => _audioRecorder.isPaused();

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _currentPath = p.join(directory.path, fileName);

        const config = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );

        await _audioRecorder.start(config, path: _currentPath!);
      } else {
        throw Exception('Microphone permission not granted');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      return path;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pauseRecording() async {
    await _audioRecorder.pause();
  }

  Future<void> resumeRecording() async {
    await _audioRecorder.resume();
  }

  Future<void> cancelRecording() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  void dispose() {
    _audioRecorder.dispose();
  }

  Stream<Amplitude> getAmplitude() {
    return _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 200));
  }
}
