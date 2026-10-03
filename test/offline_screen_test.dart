// Widget tests for Contenus hors-ligne, against a controller that only
// records what it is asked (the downloads themselves are tested apart).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/ayah_audio_cache.dart';
import 'package:sudur/core/audio/reciter.dart';
import 'package:sudur/core/offline/download_runner.dart';
import 'package:sudur/core/offline/offline_controller.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/features/settings/offline_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late QuranTextRepository _text;

class _FakeOffline extends OfflineController {
  _FakeOffline(this.initial);

  final OfflineState initial;
  final calls = <String>[];

  @override
  OfflineState build() => initial;

  @override
  Future<void> downloadAllFonts() async => calls.add('fonts');

  @override
  void cancelFonts() => calls.add('cancelFonts');

  @override
  Future<void> deleteFonts() async => calls.add('deleteFonts');

  @override
  Future<void> downloadSurah(int surah) async => calls.add('download $surah');

  @override
  void cancelAudio() => calls.add('cancelAudio');

  @override
  Future<void> deleteSurah(int surah) async => calls.add('delete $surah');

  @override
  Future<void> deleteAllAudio() async => calls.add('deleteAllAudio');
}

Future<_FakeOffline> _pump(WidgetTester tester, OfflineState state) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(900, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final fake = _FakeOffline(state);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        quranReferenceProvider.overrideWith((ref) => _reference),
        quranTextProvider.overrideWith((ref) => _text),
        offlineControllerProvider.overrideWith(() => fake),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OfflineScreen(),
      ),
    ),
  );
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return fake;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
    _text = await QuranTextRepository.load();
  });

  testWidgets('nothing downloaded: invites to download, offers no delete', (
    tester,
  ) async {
    final fake = await _pump(tester, const OfflineState(loaded: true));

    expect(tester.takeException(), isNull);
    expect(find.text('Contenus hors-ligne'), findsOneWidget);
    expect(find.text('0 pages sur 604 téléchargées'), findsOneWidget);
    expect(find.text('Tout télécharger'), findsOneWidget);
    expect(find.text('Supprimer les pages'), findsNothing);
    expect(find.text('Supprimer tout l\'audio'), findsNothing);
    expect(find.text('Espace utilisé : 0 o'), findsOneWidget);
    // The 114 sourates are listed; Al-Fatiha is the first.
    expect(
      find.text('1. ${_reference.surahByNumber(1).englishName}'),
      findsOneWidget,
    );
    expect(find.text('0 / 7 versets'), findsOneWidget);

    await tester.tap(find.text('Tout télécharger'));
    await tester.pump();
    expect(fake.calls, ['fonts']);
  });

  testWidgets('a download in progress shows its progress and can be stopped', (
    tester,
  ) async {
    final fake = await _pump(
      tester,
      const OfflineState(
        loaded: true,
        fontsProgress: DownloadProgress(total: 600, done: 200, failed: 4),
      ),
    );

    expect(find.text('204 / 600'), findsOneWidget);
    expect(find.textContaining('4 échec(s)'), findsOneWidget);
    expect(find.text('Tout télécharger'), findsNothing);

    await tester.tap(find.text('Arrêter'));
    await tester.pump();
    expect(fake.calls, ['cancelFonts']);
  });

  testWidgets('deleting asks for confirmation first', (tester) async {
    final fake = await _pump(
      tester,
      const OfflineState(
        loaded: true,
        cachedPages: {1, 2, 3},
        fontBytes: 3 * 1024 * 1024,
      ),
    );

    expect(find.text('3 pages sur 604 téléchargées'), findsOneWidget);
    expect(find.text('Espace utilisé : 3,0 Mo'), findsOneWidget);

    await tester.tap(find.text('Supprimer les pages'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Supprimer ces contenus ?'), findsOneWidget);
    expect(fake.calls, isEmpty);

    await tester.tap(find.text('Annuler'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(fake.calls, isEmpty);

    await tester.tap(find.text('Supprimer les pages'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Supprimer').last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(fake.calls, ['deleteFonts']);
  });

  testWidgets('a sourate is downloaded from its row', (tester) async {
    final fake = await _pump(tester, const OfflineState(loaded: true));

    await tester.tap(find.byTooltip('Télécharger').first);
    await tester.pump();

    expect(fake.calls, ['download 1']);
  });

  testWidgets('a complete sourate shows as downloaded and can be removed', (
    tester,
  ) async {
    final reciter = reciterById('alafasy');
    final first = _text.globalAyahNumber(1, 1);
    final fake = await _pump(
      tester,
      OfflineState(
        loaded: true,
        cachedAudio: {
          for (var i = 0; i < 7; i++)
            AyahAudioCache.fileNameForAyah(reciter, first + i),
        },
        audioBytes: 7 * 100,
      ),
    );

    expect(find.text('7 / 7 versets'), findsOneWidget);
    expect(find.byIcon(Icons.download_done), findsOneWidget);

    await tester.tap(find.byTooltip('Supprimer').first);
    await tester.pump();
    expect(fake.calls, ['delete 1']);
    expect(find.text('Supprimer tout l\'audio'), findsOneWidget);
  });

  testWidgets('while one sourate downloads the others wait', (tester) async {
    final fake = await _pump(
      tester,
      const OfflineState(
        loaded: true,
        audioSurah: 2,
        audioProgress: DownloadProgress(total: 286, done: 10, failed: 0),
      ),
    );

    final waiting = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.download_outlined).first,
    );
    expect(waiting.onPressed, isNull);

    // The running one offers to stop.
    await tester.tap(find.byTooltip('Arrêter').last);
    await tester.pump();
    expect(fake.calls, ['cancelAudio']);
  });
}
