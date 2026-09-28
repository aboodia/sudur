import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/voice_recorder.dart';

/// Optional self-recording control: tap to record, tap again to stop, then
/// replay it locally. Used on Répéter/Réciter so the user can hear their
/// own recitation back — entirely local, nothing is ever sent anywhere,
/// and staying silent about it (never auto-starting) keeps every step
/// fully usable without a mic.
class RecordControl extends ConsumerStatefulWidget {
  const RecordControl({super.key});

  @override
  ConsumerState<RecordControl> createState() => _RecordControlState();
}

class _RecordControlState extends ConsumerState<RecordControl> {
  final _previewPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _recordingPath;
  bool _permissionDenied = false;

  @override
  void dispose() {
    _previewPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    final recorder = ref.read(voiceRecorderProvider);
    if (_isRecording) {
      final path = await recorder.stopRecording();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
      return;
    }
    final started = await recorder.startRecording();
    if (!started) {
      setState(() => _permissionDenied = true);
      return;
    }
    setState(() {
      _isRecording = true;
      _recordingPath = null;
      _permissionDenied = false;
    });
  }

  Future<void> _playPreview() async {
    final path = _recordingPath;
    if (path == null) return;
    await _previewPlayer.setFilePath(path);
    await _previewPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: _isRecording
              ? 'Arrêter l\'enregistrement'
              : 'S\'enregistrer (optionnel)',
          child: IconButton(
            tooltip: _isRecording
                ? 'Arrêter l\'enregistrement'
                : 'S\'enregistrer (optionnel)',
            icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic_none),
            color: _isRecording ? Theme.of(context).colorScheme.error : null,
            onPressed: _toggleRecording,
          ),
        ),
        if (_recordingPath != null)
          Semantics(
            button: true,
            label: 'Réécouter mon enregistrement',
            child: IconButton(
              tooltip: 'Réécouter mon enregistrement',
              icon: const Icon(Icons.play_circle_outline),
              onPressed: _playPreview,
            ),
          ),
        if (_permissionDenied)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              'Micro indisponible',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
