import '../quran_reference/quran_reference_repository.dart';

class NextPassage {
  const NextPassage({
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
  });

  final int surahNumber;
  final int startAyah;
  final int endAyah;
}

/// The next passage to memorize: continues sequentially from the last
/// covered ayah, sourate by sourate from Al-Fatiha, never crossing a
/// sourate boundary, capped at [maxAyahsPerPassage] (the "session du jour"
/// mockup uses a 5-ayah example; the cahier des charges' "découpage
/// assisté" only asks for small units, so this stays a tunable default
/// rather than a hardcoded rule). `null` once every ayah is covered.
NextPassage? suggestNextPassage(
  QuranReferenceRepository reference,
  Set<String> memorizedAyahKeys, {
  int maxAyahsPerPassage = 5,
}) {
  for (final surah in reference.surahs) {
    for (var ayah = 1; ayah <= surah.numberOfAyahs; ayah++) {
      if (memorizedAyahKeys.contains('${surah.number}:$ayah')) continue;

      var end = ayah;
      while (end < surah.numberOfAyahs &&
          end - ayah + 1 < maxAyahsPerPassage &&
          !memorizedAyahKeys.contains('${surah.number}:${end + 1}')) {
        end++;
      }
      return NextPassage(
        surahNumber: surah.number,
        startAyah: ayah,
        endAyah: end,
      );
    }
  }
  return null;
}
