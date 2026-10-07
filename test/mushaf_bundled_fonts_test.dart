import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/audio/reciter.dart';
import 'package:sudur/core/mushaf/mushaf_font_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the 604 page fonts all ship with the app', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets().toSet();

    final missing = [
      for (var p = 1; p <= MushafFontCache.pageCount; p++)
        if (!assets.contains(MushafFontCache.bundledAssetFor(p))) p,
    ];

    expect(missing, isEmpty);
  });

  test(
    'a page is read from the app, with no network and no disk cache',
    () async {
      final dir = await Directory.systemTemp.createTemp('mushaf_bundle_test');
      addTearDown(() => dir.delete(recursive: true));
      var fetched = 0;
      final cache = MushafFontCache(
        directoryProvider: () async => dir,
        fetch: (_) async {
          fetched++;
          return null;
        },
        bundle: rootBundle,
      );

      expect(cache.isBundled, isTrue);
      expect(
        await cache.fontFamilyForPage(1),
        MushafFontCache.familyForPage(1),
      );
      expect(
        await cache.fontFamilyForPage(604),
        MushafFontCache.familyForPage(604),
      );
      expect(fetched, 0);
      expect(dir.listSync(), isEmpty);
    },
  );

  test('a page missing from the bundle falls back to the download', () async {
    final dir = await Directory.systemTemp.createTemp('mushaf_bundle_test');
    addTearDown(() => dir.delete(recursive: true));
    final cache = MushafFontCache(
      directoryProvider: () async => dir,
      fetch: (_) async => null,
      bundle: _EmptyBundle(),
    );

    expect(await cache.fontFamilyForPage(1), isNull);
  });

  test('without a bundle the cache is not bundled', () {
    expect(MushafFontCache().isBundled, isFalse);
  });

  test('Maher Al-Muaiqly is offered, with his own audio', () {
    final r = reciterById('muaiqly');

    expect(r.name, 'Maher Al-Muaiqly');
    expect(ayahAudioUrl(r, 1), contains('/ar.mahermuaiqly/1.mp3'));
    expect(kReciters.map((r) => r.id).toSet(), hasLength(kReciters.length));
  });
}

class _EmptyBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) =>
      Future.error(Exception('no such asset: $key'));
}
