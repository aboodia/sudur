// Opening the text view of a sourate (from the Mushaf's top-right button)
// must not touch the player while the screen is being built: Riverpod
// refuses that with "Tried to modify a provider while the widget tree was
// building".

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/audio_playback_controller.dart';
import 'package:sudur/core/audio/playback_state.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/features/reading/surah_reading_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late QuranTextRepository _text;

/// A player that plays nothing (no audio plugin in tests).
class _SilentPlayback extends AudioPlaybackController {
  @override
  ReadingPlaybackState build() => const ReadingPlaybackState();

  @override
  Stream<Duration> get positionStream => const Stream.empty();

  @override
  Stream<Duration?> get durationStream => const Stream.empty();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
    _text = await QuranTextRepository.load();
  });

  testWidgets('opening a sourate lines up the player without a build error', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
          quranReferenceProvider.overrideWith((ref) => _reference),
          quranTextProvider.overrideWith((ref) => _text),
          audioPlaybackProvider.overrideWith(_SilentPlayback.new),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SurahReadingScreen(surahNumber: 67, initialAyah: 3),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SurahReadingScreen)),
    );
    final playback = container.read(audioPlaybackProvider);
    expect((playback.surahNumber, playback.ayahNumber), (67, 3));
    expect(playback.isPlaying, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });
}
