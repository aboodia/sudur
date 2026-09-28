import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Optional voice recording for the Réciter step — local only, nothing is
/// ever uploaded or sent over the network. The mic permission is requested
/// lazily, the first time [startRecording] is actually called, never at app
/// startup, so the parcours stays fully usable for anyone who never taps
/// the mic button.
class VoiceRecorder {
  final _recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  Future<bool> get isRecording => _recorder.isRecording();

  /// Starts recording to a fresh temp file, requesting mic permission first
  /// if it isn't already granted. Returns false without starting if the
  /// user declines — callers must treat that as "recording unavailable",
  /// never as a hard error, since recording is always optional.
  Future<bool> startRecording() async {
    if (!await hasPermission()) return false;
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/recite_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(), path: path);
    return true;
  }

  /// Stops the current recording and returns its local file path (playable
  /// straight back with just_audio), or null if nothing was recording.
  Future<String?> stopRecording() => _recorder.stop();

  void dispose() => _recorder.dispose();
}

final voiceRecorderProvider = Provider<VoiceRecorder>((ref) {
  final recorder = VoiceRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});
