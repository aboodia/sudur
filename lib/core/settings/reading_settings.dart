import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mode Arabe seul / Translittération / Bilingue (Brique 1) — all three
/// reuse the same [textScale] zoom setting.
enum ReadingDisplayMode { arabicOnly, transliteration, bilingual }

extension ReadingDisplayModeLabel on ReadingDisplayMode {
  String get label => switch (this) {
        ReadingDisplayMode.arabicOnly => 'Arabe',
        ReadingDisplayMode.transliteration => 'Translittération',
        ReadingDisplayMode.bilingual => 'Bilingue',
      };
}

class ReadingSettings {
  const ReadingSettings({
    this.displayMode = ReadingDisplayMode.arabicOnly,
    this.textScale = 1.0,
  });

  final ReadingDisplayMode displayMode;
  final double textScale;

  ReadingSettings copyWith({ReadingDisplayMode? displayMode, double? textScale}) =>
      ReadingSettings(
        displayMode: displayMode ?? this.displayMode,
        textScale: textScale ?? this.textScale,
      );
}

const _kDisplayModeKey = 'reading.displayMode';
const _kTextScaleKey = 'reading.textScale';
const kMinTextScale = 0.75;
const kMaxTextScale = 2.0;

class ReadingSettingsController extends Notifier<ReadingSettings> {
  @override
  ReadingSettings build() {
    _restore();
    return const ReadingSettings();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_kDisplayModeKey);
    final scale = prefs.getDouble(_kTextScaleKey);
    state = ReadingSettings(
      displayMode: modeIndex != null && modeIndex < ReadingDisplayMode.values.length
          ? ReadingDisplayMode.values[modeIndex]
          : ReadingDisplayMode.arabicOnly,
      textScale: scale ?? 1.0,
    );
  }

  Future<void> setDisplayMode(ReadingDisplayMode mode) async {
    state = state.copyWith(displayMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kDisplayModeKey, mode.index);
  }

  Future<void> setTextScale(double scale) async {
    final clamped = scale.clamp(kMinTextScale, kMaxTextScale);
    state = state.copyWith(textScale: clamped);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kTextScaleKey, clamped);
  }
}

final readingSettingsProvider =
    NotifierProvider<ReadingSettingsController, ReadingSettings>(
  ReadingSettingsController.new,
);
