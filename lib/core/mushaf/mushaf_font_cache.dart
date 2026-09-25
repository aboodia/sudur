import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Downloads and caches, one page at a time, the QCF v4 tajweed font for
/// that Mushaf page (public CDN, no API key). Bundling all 604 page fonts
/// (~160MB as TTF) in the app isn't practical, so pages are fetched on
/// first view and kept on disk for offline reuse afterwards — the same
/// "téléchargement des contenus" pattern the cahier des charges describes
/// for offline mode (§4.9), just scoped to fonts for now.
///
/// TTF, not WOFF2: [FontLoader] only supports OpenType/TrueType.
class MushafFontCache {
  final _loadedPages = <int>{};
  Directory? _cacheDir;

  static String familyForPage(int page) => 'mushaf_p$page';

  static String _cdnUrl(int page) =>
      'https://static-cdn.tarteel.ai/qul/fonts/quran_fonts/v4-tajweed/ttf/p$page.ttf';

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final support = await getApplicationSupportDirectory();
    final dir = Directory('${support.path}/mushaf_fonts');
    if (!await dir.exists()) await dir.create(recursive: true);
    _cacheDir = dir;
    return dir;
  }

  /// Registers page [page]'s font with the engine (from disk cache, or by
  /// downloading it first) and returns the font family to render it with.
  /// Returns null if the font isn't cached and couldn't be downloaded
  /// (offline + never viewed before) — callers should show a fallback.
  Future<String?> fontFamilyForPage(int page) async {
    final family = familyForPage(page);
    if (_loadedPages.contains(page)) return family;

    final dir = await _dir();
    final file = File('${dir.path}/p$page.ttf');
    Uint8List bytes;
    if (await file.exists()) {
      bytes = await file.readAsBytes();
    } else {
      final downloaded = await _download(page);
      if (downloaded == null) return null;
      bytes = downloaded;
      unawaited(file.writeAsBytes(bytes));
    }

    final loader = FontLoader(family)..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
    _loadedPages.add(page);
    return family;
  }

  Future<Uint8List?> _download(int page) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(_cdnUrl(page)));
      final response = await request.close();
      if (response.statusCode != 200) return null;
      final builder = BytesBuilder();
      await for (final chunk in response) {
        builder.add(chunk);
      }
      return builder.takeBytes();
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}

final mushafFontCacheProvider = Provider<MushafFontCache>((ref) => MushafFontCache());

final mushafPageFontProvider = FutureProvider.family<String?, int>((ref, page) {
  return ref.watch(mushafFontCacheProvider).fontFamilyForPage(page);
});
