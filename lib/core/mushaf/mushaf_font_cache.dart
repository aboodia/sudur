import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Fetches [url]; null if it could not be downloaded.
typedef Fetch = Future<Uint8List?> Function(String url);

/// The plain HTTP download used by the app's caches.
Future<Uint8List?> httpFetch(String url) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
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

/// Downloads and caches, one page at a time, the QCF v4 tajweed font for
/// that Mushaf page (public CDN, no API key). Bundling all 604 page fonts
/// (about 0.8 MB each as TTF, roughly 470 MB for the 604, measured on a phone) in the app isn't practical, so pages are fetched on
/// first view and kept on disk for offline reuse afterwards — or all at
/// once from the offline-content screen ([downloadPage]).
///
/// TTF, not WOFF2: [FontLoader] only supports OpenType/TrueType.
class MushafFontCache {
  MushafFontCache({this.directoryProvider, Fetch? fetch})
    : _fetch = fetch ?? httpFetch;

  /// Where the cache lives; the app's support folder when null (tests
  /// give a temporary one).
  final Future<Directory> Function()? directoryProvider;
  final Fetch _fetch;
  final _loadedPages = <int>{};
  Directory? _cacheDir;

  static const pageCount = 604;

  static String familyForPage(int page) => 'mushaf_p$page';

  static String _cdnUrl(int page) =>
      'https://static-cdn.tarteel.ai/qul/fonts/quran_fonts/v4-tajweed/ttf/p$page.ttf';

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final Directory dir;
    if (directoryProvider != null) {
      dir = await directoryProvider!();
    } else {
      final support = await getApplicationSupportDirectory();
      dir = Directory('${support.path}/mushaf_fonts');
    }
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
      final downloaded = await _fetch(_cdnUrl(page));
      if (downloaded == null) return null;
      bytes = downloaded;
      unawaited(file.writeAsBytes(bytes));
    }

    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
    _loadedPages.add(page);
    return family;
  }

  /// Makes sure page [page]'s font is on disk, downloading it if needed,
  /// without loading it into the engine. True if it is there afterwards.
  Future<bool> downloadPage(int page) async {
    final dir = await _dir();
    final file = File('${dir.path}/p$page.ttf');
    if (await file.exists()) return true;
    final bytes = await _fetch(_cdnUrl(page));
    if (bytes == null) return false;
    await file.writeAsBytes(bytes);
    return true;
  }

  /// The pages whose font is on disk.
  Future<Set<int>> cachedPages() async {
    final dir = await _dir();
    final pages = <int>{};
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      final match = RegExp(r'p(\d+)\.ttf$').firstMatch(entity.path);
      if (match != null) pages.add(int.parse(match.group(1)!));
    }
    return pages;
  }

  /// Bytes taken on disk.
  Future<int> sizeOnDisk() async {
    final dir = await _dir();
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  /// Removes every cached font. Pages already loaded stay displayable until
  /// the app restarts; they are downloaded again when next needed.
  Future<void> deleteAll() async {
    final dir = await _dir();
    await for (final entity in dir.list()) {
      if (entity is File) await entity.delete();
    }
    _loadedPages.clear();
  }
}

final mushafFontCacheProvider = Provider<MushafFontCache>(
  (ref) => MushafFontCache(),
);

final mushafPageFontProvider = FutureProvider.family<String?, int>((ref, page) {
  return ref.watch(mushafFontCacheProvider).fontFamilyForPage(page);
});
