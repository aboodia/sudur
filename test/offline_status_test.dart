import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/audio/ayah_audio_cache.dart';
import 'package:sudur/core/audio/reciter.dart';
import 'package:sudur/core/offline/offline_status.dart';

void main() {
  final alafasy = reciterById('alafasy');
  final husary = reciterById('husary');

  group('cachedAyahCount', () {
    test('counts only the verses of that sourate for that reciter', () {
      // A sourate of 5 verses starting at global verse 100.
      final cached = {
        AyahAudioCache.fileNameForAyah(alafasy, 100),
        AyahAudioCache.fileNameForAyah(alafasy, 102),
        AyahAudioCache.fileNameForAyah(alafasy, 104),
        AyahAudioCache.fileNameForAyah(alafasy, 105), // next sourate
        AyahAudioCache.fileNameForAyah(husary, 101), // another reciter
      };

      expect(
        cachedAyahCount(
          cachedFileNames: cached,
          reciter: alafasy,
          firstGlobal: 100,
          ayahCount: 5,
        ),
        3,
      );
    });

    test('nothing cached is zero', () {
      expect(
        cachedAyahCount(
          cachedFileNames: {},
          reciter: alafasy,
          firstGlobal: 1,
          ayahCount: 7,
        ),
        0,
      );
    });

    test('a complete sourate counts every verse', () {
      final names = surahFileNames(
        reciter: alafasy,
        firstGlobal: 1,
        ayahCount: 7,
      );
      expect(
        cachedAyahCount(
          cachedFileNames: names.toSet(),
          reciter: alafasy,
          firstGlobal: 1,
          ayahCount: 7,
        ),
        7,
      );
    });
  });

  test('surahFileNames lists one distinct file per verse', () {
    final names = surahFileNames(
      reciter: alafasy,
      firstGlobal: 6232,
      ayahCount: 5,
    );
    expect(names, hasLength(5));
    expect(names.toSet(), hasLength(5));
  });

  group('formatBytes', () {
    test('picks a readable unit with a French decimal comma', () {
      expect(formatBytes(0), '0 o');
      expect(formatBytes(900), '900 o');
      expect(formatBytes(2048), '2 Ko');
      expect(formatBytes(1024 * 1024 * 12 + 1024 * 400), '12,4 Mo');
      expect(formatBytes(1024 * 1024 * 1024 * 2), '2,00 Go');
    });
  });

  group('estimateRemainingFontBytes', () {
    test('uses the average size of the pages already on disk', () {
      // 10 pages weighing 1000 bytes: 594 pages left at 100 bytes each.
      expect(
        estimateRemainingFontBytes(
          cachedPages: 10,
          fontBytes: 1000,
          totalPages: 604,
        ),
        59400,
      );
    });

    test('says nothing from too small a sample', () {
      expect(
        estimateRemainingFontBytes(
          cachedPages: 2,
          fontBytes: 1000,
          totalPages: 604,
        ),
        isNull,
      );
      expect(
        estimateRemainingFontBytes(
          cachedPages: 0,
          fontBytes: 0,
          totalPages: 604,
        ),
        isNull,
      );
    });

    test('nothing left means no estimate', () {
      expect(
        estimateRemainingFontBytes(
          cachedPages: 604,
          fontBytes: 1000,
          totalPages: 604,
        ),
        isNull,
      );
    });
  });
}
