import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../mushaf/mushaf_font_cache.dart' show Fetch, httpFetch;
import 'reciter.dart';

/// Downloads and caches ayah recitation audio on disk, one file at a time —
/// the same "télécharger au premier usage, puis servir depuis le disque"
/// pattern as [MushafFontCache], applied to audio instead of fonts, so a
/// passage already worked through (Découvrir/Répéter/Réciter) stays
/// listenable offline afterwards. Whole sourates can also be fetched ahead
/// of time from the offline-content screen ([download]).
class AyahAudioCache {
  AyahAudioCache({this.directoryProvider, Fetch? fetch})
    : _fetch = fetch ?? httpFetch;

  /// Where the cache lives; the app's support folder when null (tests
  /// give a temporary one).
  final Future<Directory> Function()? directoryProvider;
  final Fetch _fetch;
  Directory? _cacheDir;

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final Directory dir;
    if (directoryProvider != null) {
      dir = await directoryProvider!();
    } else {
      final support = await getApplicationSupportDirectory();
      dir = Directory('${support.path}/ayah_audio');
    }
    if (!await dir.exists()) await dir.create(recursive: true);
    _cacheDir = dir;
    return dir;
  }

  /// The file name an audio URL is cached under: the URL already encodes
  /// reciter + ayah + bitrate uniquely
  /// (`cdn.islamic.network/quran/audio/BITRATE/EDITION/GLOBAL.mp3`), so
  /// its last two segments — edition and verse — are the key.
  static String fileNameFor(String url) {
    final parts = url.split('/');
    final safe = parts.skip(parts.length - 2).join('_');
    return safe.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }

  /// The cache file name of verse [globalAyahNumber] (1-6236) by [reciter].
  static String fileNameForAyah(Reciter reciter, int globalAyahNumber) =>
      fileNameFor(ayahAudioUrl(reciter, globalAyahNumber));

  /// Returns a local file path playable by just_audio for [url]'s audio,
  /// downloading and caching it first if needed. Returns null only when
  /// nothing is cached yet and the download failed (offline, first time) —
  /// callers should fall back to streaming [url] directly in that case.
  Future<String?> localPathFor(String url) async {
    final dir = await _dir();
    final file = File('${dir.path}/${fileNameFor(url)}');
    if (await file.exists()) return file.path;

    final bytes = await _fetch(url);
    if (bytes == null) return null;
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Makes sure [url]'s audio is on disk. True if it is there afterwards.
  Future<bool> download(String url) async => await localPathFor(url) != null;

  /// The names of the files on disk — [fileNameForAyah] says which verse
  /// and reciter each one is.
  Future<Set<String>> cachedFileNames() async {
    final dir = await _dir();
    final names = <String>{};
    await for (final entity in dir.list()) {
      if (entity is File) {
        names.add(entity.uri.pathSegments.last);
      }
    }
    return names;
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

  /// Removes the given cached files (names as in [cachedFileNames]).
  Future<void> delete(Iterable<String> fileNames) async {
    final dir = await _dir();
    for (final name in fileNames) {
      final file = File('${dir.path}/$name');
      if (await file.exists()) await file.delete();
    }
  }

  Future<void> deleteAll() async => delete(await cachedFileNames());
}

final ayahAudioCacheProvider = Provider<AyahAudioCache>(
  (ref) => AyahAudioCache(),
);
