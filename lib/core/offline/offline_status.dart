import '../audio/ayah_audio_cache.dart';
import '../audio/reciter.dart';

// What is available offline — pure logic, no Flutter and no disk access.

/// How many verses of a sourate are cached for [reciter]. [firstGlobal] is
/// the sourate's first verse numbered across the whole Quran (1-6236), and
/// [ayahCount] its number of verses.
int cachedAyahCount({
  required Set<String> cachedFileNames,
  required Reciter reciter,
  required int firstGlobal,
  required int ayahCount,
}) {
  var n = 0;
  for (var i = 0; i < ayahCount; i++) {
    if (cachedFileNames.contains(
      AyahAudioCache.fileNameForAyah(reciter, firstGlobal + i),
    )) {
      n++;
    }
  }
  return n;
}

/// The file names of a whole sourate for [reciter].
List<String> surahFileNames({
  required Reciter reciter,
  required int firstGlobal,
  required int ayahCount,
}) => [
  for (var i = 0; i < ayahCount; i++)
    AyahAudioCache.fileNameForAyah(reciter, firstGlobal + i),
];

/// "12,4 Mo", "850 Ko", "0 Ko" — a French decimal comma. Sizes are
/// measured from the files on disk, never estimated.
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes o';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.round()} Ko';
  final mb = kb / 1024;
  if (mb < 1024) return '${mb.toStringAsFixed(1).replaceAll('.', ',')} Mo';
  final gb = mb / 1024;
  return '${gb.toStringAsFixed(2).replaceAll('.', ',')} Go';
}

/// How much is still to download for the Mushaf pages, estimated from the
/// pages already on disk (their average size) — null while there are too
/// few of them to tell, so no figure is ever invented.
int? estimateRemainingFontBytes({
  required int cachedPages,
  required int fontBytes,
  required int totalPages,
}) {
  const minimumSample = 5;
  if (cachedPages < minimumSample || cachedPages >= totalPages) return null;
  return (fontBytes / cachedPages * (totalPages - cachedPages)).round();
}
