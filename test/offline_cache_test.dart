import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/audio/ayah_audio_cache.dart';
import 'package:sudur/core/audio/reciter.dart';
import 'package:sudur/core/mushaf/mushaf_font_cache.dart';
import 'package:sudur/core/offline/download_runner.dart';

Uint8List _bytes(int n) => Uint8List.fromList(List.filled(n, 7));

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('sudur_cache_test');
  });
  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  group('MushafFontCache', () {
    MushafFontCache cache({Fetch? fetch}) => MushafFontCache(
      directoryProvider: () async => Directory('${tmp.path}/fonts'),
      fetch: fetch ?? (url) async => _bytes(100),
    );

    test('downloading a page puts its font on disk', () async {
      final c = cache();

      expect(await c.downloadPage(3), isTrue);

      expect(await c.cachedPages(), {3});
      expect(await c.sizeOnDisk(), 100);
    });

    test('a page already on disk is not fetched again', () async {
      var calls = 0;
      final c = cache(
        fetch: (url) async {
          calls++;
          return _bytes(10);
        },
      );

      await c.downloadPage(5);
      await c.downloadPage(5);

      expect(calls, 1);
    });

    test('a failed download leaves nothing behind', () async {
      final c = cache(fetch: (url) async => null);

      expect(await c.downloadPage(9), isFalse);

      expect(await c.cachedPages(), isEmpty);
    });

    test('the right page is asked for', () async {
      final urls = <String>[];
      final c = cache(
        fetch: (url) async {
          urls.add(url);
          return _bytes(1);
        },
      );

      await c.downloadPage(604);

      expect(urls.single, endsWith('/p604.ttf'));
    });

    test('deleting empties the cache', () async {
      final c = cache();
      await c.downloadPage(1);
      await c.downloadPage(2);

      await c.deleteAll();

      expect(await c.cachedPages(), isEmpty);
      expect(await c.sizeOnDisk(), 0);
    });
  });

  group('AyahAudioCache', () {
    AyahAudioCache cache({Fetch? fetch}) => AyahAudioCache(
      directoryProvider: () async => Directory('${tmp.path}/audio'),
      fetch: fetch ?? (url) async => _bytes(50),
    );
    final alafasy = reciterById('alafasy');
    final husary = reciterById('husary');

    String url(Reciter r, int n) => ayahAudioUrl(r, n);

    test('the file name says which reciter and which verse', () {
      expect(
        AyahAudioCache.fileNameFor(url(alafasy, 123)),
        AyahAudioCache.fileNameForAyah(alafasy, 123),
      );
      expect(
        AyahAudioCache.fileNameForAyah(alafasy, 1),
        isNot(AyahAudioCache.fileNameForAyah(husary, 1)),
      );
      expect(
        AyahAudioCache.fileNameForAyah(alafasy, 1),
        isNot(AyahAudioCache.fileNameForAyah(alafasy, 2)),
      );
    });

    test('a downloaded verse is listed under its file name', () async {
      final c = cache();

      expect(await c.download(url(alafasy, 8)), isTrue);

      expect(await c.cachedFileNames(), {
        AyahAudioCache.fileNameForAyah(alafasy, 8),
      });
      expect(await c.sizeOnDisk(), 50);
    });

    test('playing and downloading share the same cache', () async {
      var calls = 0;
      final c = cache(
        fetch: (u) async {
          calls++;
          return _bytes(5);
        },
      );

      await c.download(url(alafasy, 8));
      final path = await c.localPathFor(url(alafasy, 8));

      expect(path, isNotNull);
      expect(calls, 1);
    });

    test('a failed download is reported and caches nothing', () async {
      final c = cache(fetch: (u) async => null);

      expect(await c.download(url(alafasy, 8)), isFalse);
      expect(await c.localPathFor(url(alafasy, 8)), isNull);
      expect(await c.cachedFileNames(), isEmpty);
    });

    test('deleting some files leaves the others', () async {
      final c = cache();
      await c.download(url(alafasy, 1));
      await c.download(url(alafasy, 2));
      await c.download(url(husary, 1));

      await c.delete([AyahAudioCache.fileNameForAyah(alafasy, 1)]);

      expect(await c.cachedFileNames(), {
        AyahAudioCache.fileNameForAyah(alafasy, 2),
        AyahAudioCache.fileNameForAyah(husary, 1),
      });
      await c.deleteAll();
      expect(await c.cachedFileNames(), isEmpty);
    });
  });

  group('runDownloads', () {
    test('downloads everything and reports each step', () async {
      final seen = <int>[];
      final result = await runDownloads<int>(
        [1, 2, 3, 4, 5],
        (i) async => true,
        onProgress: (p) => seen.add(p.finished),
      );

      expect(result.total, 5);
      expect(result.done, 5);
      expect(result.failed, 0);
      expect(result.complete, isTrue);
      expect(seen, [1, 2, 3, 4, 5]);
    });

    test('a failure or an exception counts as failed, not as a stop', () async {
      final result = await runDownloads<int>([1, 2, 3, 4], (i) async {
        if (i == 2) return false;
        if (i == 3) throw StateError('network');
        return true;
      });

      expect(result.done, 2);
      expect(result.failed, 2);
      expect(result.complete, isTrue);
    });

    test('never more than the allowed number at once', () async {
      var running = 0;
      var peak = 0;
      await runDownloads<int>(List.generate(12, (i) => i), (i) async {
        running++;
        if (running > peak) peak = running;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        running--;
        return true;
      }, concurrency: 3);

      expect(peak, lessThanOrEqualTo(3));
      expect(peak, greaterThan(1));
    });

    test('cancelling stops starting new items', () async {
      var cancelled = false;
      final started = <int>[];
      final result = await runDownloads<int>(
        List.generate(20, (i) => i),
        (i) async {
          started.add(i);
          if (i == 4) cancelled = true;
          return true;
        },
        concurrency: 1,
        isCancelled: () => cancelled,
      );

      expect(started, [0, 1, 2, 3, 4]);
      expect(result.done, 5);
      expect(result.complete, isFalse);
      expect(result.fraction, closeTo(5 / 20, 1e-9));
    });

    test('an empty batch is complete', () async {
      final result = await runDownloads<int>(const [], (i) async => true);
      expect(result.complete, isTrue);
      expect(result.fraction, 1);
    });
  });
}
