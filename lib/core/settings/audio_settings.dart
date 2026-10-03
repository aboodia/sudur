import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audio/reciter.dart';

/// Playback speeds offered, in the mini-player and in the settings.
const kPlaybackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

/// The reciter and speed the user prefers — used whenever the app starts,
/// and updated whenever they change either in the mini-player or in the
/// settings.
class AudioSettings {
  const AudioSettings({
    this.reciterId = kDefaultReciterId,
    this.speed = 1.0,
    this.loaded = false,
  });

  final String reciterId;
  final double speed;

  /// Whether the saved values have been read yet.
  final bool loaded;

  AudioSettings copyWith({String? reciterId, double? speed}) => AudioSettings(
    reciterId: reciterId ?? this.reciterId,
    speed: speed ?? this.speed,
    loaded: true,
  );
}

const _kReciterKey = 'audio.reciterId';
const _kSpeedKey = 'audio.speed';

class AudioSettingsController extends Notifier<AudioSettings> {
  @override
  AudioSettings build() {
    _restore();
    return const AudioSettings();
  }

  Future<void> _restore() async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Storage unavailable: the defaults stand, and the app goes on.
    }
    if (!ref.mounted) return;
    final reciter = prefs?.getString(_kReciterKey);
    final speed = prefs?.getDouble(_kSpeedKey);
    state = AudioSettings(
      // A reciter that is no longer offered falls back to the default.
      reciterId: kReciters.any((r) => r.id == reciter)
          ? reciter!
          : kDefaultReciterId,
      speed: kPlaybackSpeeds.contains(speed) ? speed! : 1.0,
      loaded: true,
    );
  }

  Future<void> setReciter(String reciterId) async {
    if (state.loaded && state.reciterId == reciterId) return;
    state = state.copyWith(reciterId: reciterId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kReciterKey, reciterId);
  }

  Future<void> setSpeed(double speed) async {
    if (state.loaded && state.speed == speed) return;
    state = state.copyWith(speed: speed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kSpeedKey, speed);
  }
}

final audioSettingsProvider =
    NotifierProvider<AudioSettingsController, AudioSettings>(
      AudioSettingsController.new,
    );
