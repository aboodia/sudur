import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Downloads and caches ayah recitation audio on disk, one file at a time —
/// the same "télécharger au premier usage, puis servir depuis le disque"
/// pattern as [MushafFontCache], applied to audio instead of fonts, so a
/// passage already worked through (Découvrir/Répéter/Réciter) stays
/// listenable offline afterwards.
class AyahAudioCache {
  Directory? _cacheDir;

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final support = await getApplicationSupportDirectory();
    final dir = Directory('${support.path}/ayah_audio');
    if (!await dir.exists()) await dir.create(recursive: true);
    _cacheDir = dir;
    return dir;
  }

  String _fileNameFor(String url) {
    // The URL already encodes reciter + ayah + bitrate uniquely
    // (cdn.islamic.network/quran/audio/<bitrate>/<edition>/<global>.mp3) —
    // reusing its tail as the cache key keeps this independent of any
    // particular reciter list shape.
    final safe = url.split('/').skip(url.split('/').length - 2).join('_');
    return safe.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }

  /// Returns a local file path playable by just_audio for [url]'s audio,
  /// downloading and caching it first if needed. Returns null only when
  /// nothing is cached yet and the download failed (offline, first time) —
  /// callers should fall back to streaming [url] directly in that case.
  Future<String?> localPathFor(String url) async {
    final dir = await _dir();
    final file = File('${dir.path}/${_fileNameFor(url)}');
    if (await file.exists()) return file.path;

    final bytes = await _download(url);
    if (bytes == null) return null;
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<Uint8List?> _download(String url) async {
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
}

final ayahAudioCacheProvider = Provider<AyahAudioCache>(
  (ref) => AyahAudioCache(),
);
