@Timeout(Duration(minutes: 3))
// These write the 604 page files to disk: on a busy machine the default 30
// seconds is not always enough.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/ayah_audio_cache.dart';
import 'package:sudur/core/audio/reciter.dart';
import 'package:sudur/core/mushaf/mushaf_font_cache.dart';
import 'package:sudur/core/offline/offline_controller.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/core/settings/audio_settings.dart';

Uint8List _bytes(int n) => Uint8List.fromList(List.filled(n, 1));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late ProviderContainer container;
  late List<String> fetched;
  var failing = <String>{};

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tmp = await Directory.systemTemp.createTemp('sudur_offline_test');
    fetched = [];
    failing = {};
    Future<Uint8List?> fetch(String url) async {
      fetched.add(url);
      if (failing.any(url.contains)) return null;
      return _bytes(10);
    }

    container = ProviderContainer(
      overrides: [
        mushafFontCacheProvider.overrideWithValue(
          MushafFontCache(
            directoryProvider: () async => Directory('${tmp.path}/fonts'),
            fetch: fetch,
          ),
        ),
        ayahAudioCacheProvider.overrideWithValue(
          AyahAudioCache(
            directoryProvider: () async => Directory('${tmp.path}/audio'),
            fetch: fetch,
          ),
        ),
      ],
    );
    // Let the saved audio settings load, then the first scan of the disk.
    container.read(audioSettingsProvider);
    container.read(offlineControllerProvider);
    // Wait for both to have read their disk, however busy the machine is.
    for (var i = 0; i < 200; i++) {
      if (container.read(offlineControllerProvider).loaded &&
          container.read(audioSettingsProvider).loaded) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  });

  tearDown(() async {
    container.dispose();
    await tmp.delete(recursive: true);
  });

  OfflineState state() => container.read(offlineControllerProvider);
  OfflineController controller() =>
      container.read(offlineControllerProvider.notifier);

  test('starts empty once the disk has been read', () {
    expect(state().loaded, isTrue);
    expect(state().cachedPages, isEmpty);
    expect(state().cachedAudio, isEmpty);
    expect(state().totalBytes, 0);
    expect(state().fontsComplete, isFalse);
  });

  test('downloading all the Mushaf pages fills the cache', () async {
    await controller().downloadAllFonts();

    expect(state().cachedPages, hasLength(MushafFontCache.pageCount));
    expect(state().fontsComplete, isTrue);
    expect(state().fontsRunning, isFalse);
    expect(state().fontBytes, 10 * MushafFontCache.pageCount);
  });

  test('pages already on disk are not fetched again', () async {
    await container.read(mushafFontCacheProvider).downloadPage(1);
    await controller().refresh();
    fetched.clear();

    await controller().downloadAllFonts();

    expect(fetched, hasLength(MushafFontCache.pageCount - 1));
    expect(fetched.any((u) => u.endsWith('/p1.ttf')), isFalse);
  });

  test('failed pages are left for a retry, not recorded', () async {
    failing = {'/p7.ttf', '/p8.ttf'};

    await controller().downloadAllFonts();

    expect(state().cachedPages, hasLength(MushafFontCache.pageCount - 2));
    expect(state().cachedPages, isNot(contains(7)));
    failing = {};
    await controller().downloadAllFonts();
    expect(state().fontsComplete, isTrue);
  });

  test('deleting the pages empties the cache', () async {
    await container.read(mushafFontCacheProvider).downloadPage(2);
    await controller().refresh();

    await controller().deleteFonts();

    expect(state().cachedPages, isEmpty);
  });

  test('downloading a sourate caches each of its verses', () async {
    await controller().downloadSurah(1);

    final reference = await container.read(quranReferenceProvider.future);
    final text = await container.read(quranTextProvider.future);
    final reciter = reciterById(
      container.read(audioSettingsProvider).reciterId,
    );
    final expected = {
      for (var a = 1; a <= reference.surahByNumber(1).numberOfAyahs; a++)
        AyahAudioCache.fileNameForAyah(reciter, text.globalAyahNumber(1, a)),
    };
    expect(state().cachedAudio, expected);
    expect(state().audioRunning, isFalse);
    expect(
      controller().cachedVerses(
        1,
        first: text.globalAyahNumber(1, 1),
        count: 7,
      ),
      7,
    );
  });

  test('audio is downloaded for the preferred reciter', () async {
    await container.read(audioSettingsProvider.notifier).setReciter('husary');

    await controller().downloadSurah(112);

    expect(fetched, isNotEmpty);
    expect(fetched.every((u) => u.contains('ar.husary')), isTrue);
  });

  test('deleting one sourate keeps the others', () async {
    await controller().downloadSurah(1);
    await controller().downloadSurah(112);
    final both = state().cachedAudio.length;

    await controller().deleteSurah(112);

    expect(state().cachedAudio.length, 7);
    expect(state().cachedAudio.length, lessThan(both));
  });

  test('deleting all the audio empties it', () async {
    await controller().downloadSurah(1);

    await controller().deleteAllAudio();

    expect(state().cachedAudio, isEmpty);
    expect(state().audioBytes, 0);
  });

  test('one audio download at a time', () async {
    final first = controller().downloadSurah(2);
    // Started while the first is still running: ignored.
    await Future<void>.delayed(const Duration(milliseconds: 1));
    await controller().downloadSurah(1);
    await first;

    expect(state().cachedAudio.length, lessThanOrEqualTo(286));
    expect(state().audioRunning, isFalse);
  });
}
