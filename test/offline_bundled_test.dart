// With the Mushaf fonts shipped in the app, the offline screen has nothing to
// download for them and the pages an older version downloaded are removed.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/ayah_audio_cache.dart';
import 'package:sudur/core/mushaf/mushaf_font_cache.dart';
import 'package:sudur/core/offline/offline_controller.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/features/settings/offline_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

class _FakeOffline extends OfflineController {
  @override
  OfflineState build() => const OfflineState(loaded: true, fontsBundled: true);
}

void main() {
  // Loaded once, outside the widget test: an asset load does not complete in
  // a test's fake-async zone.
  late QuranReferenceRepository reference;
  late QuranTextRepository text;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
    text = await QuranTextRepository.load();
  });

  test('every page counts as there, and old downloads are removed', () async {
    SharedPreferences.setMockInitialValues({});
    final tmp = await Directory.systemTemp.createTemp('sudur_bundled_test');
    addTearDown(() => tmp.delete(recursive: true));
    final fonts = Directory('${tmp.path}/fonts')..createSync();
    File('${fonts.path}/p5.ttf').writeAsBytesSync([1, 2, 3]);

    final container = ProviderContainer(
      overrides: [
        mushafFontCacheProvider.overrideWithValue(
          MushafFontCache(
            directoryProvider: () async => fonts,
            bundle: rootBundle,
          ),
        ),
        ayahAudioCacheProvider.overrideWithValue(
          AyahAudioCache(
            directoryProvider: () async => Directory('${tmp.path}/audio'),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(offlineControllerProvider);
    for (var i = 0; i < 200; i++) {
      if (container.read(offlineControllerProvider).loaded) break;
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }

    final state = container.read(offlineControllerProvider);
    expect(state.fontsBundled, isTrue);
    expect(state.fontsComplete, isTrue);
    expect(state.cachedPages, hasLength(MushafFontCache.pageCount));
    expect(state.fontBytes, 0);
    expect(fonts.listSync(), isEmpty);
  });

  testWidgets('the screen says the pages are in the app, nothing to download', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranReferenceProvider.overrideWith((ref) => reference),
          quranTextProvider.overrideWith((ref) => text),
          offlineControllerProvider.overrideWith(_FakeOffline.new),
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

    expect(tester.takeException(), isNull);
    expect(
      find.text(
        'Les 604 pages sont dans l\'application : elles se lisent sans connexion.',
      ),
      findsOneWidget,
    );
    expect(find.text('Tout télécharger'), findsNothing);
    expect(find.text('Supprimer les pages'), findsNothing);
  });
}
