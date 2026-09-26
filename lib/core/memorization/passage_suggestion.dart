import '../database/app_database.dart';
import '../quran_reference/quran_reference_repository.dart';

/// A 1-3 ayah passage suggested as the next thing to memorize.
class NextPassage {
  const NextPassage({required this.surahNumber, required this.startAyah, required this.endAyah});

  final int surahNumber;
  final int startAyah;
  final int endAyah;
}

/// Découpage assisté (Brique 3) : suggests the next 1-3 uncovered ayahs,
/// continuing sequentially from Al-Fatiha — never crossing a sourate
/// boundary, and never overlapping a passage already `learning` or
/// `memorized` (both count as "covered", so a session in progress is never
/// suggested again). Returns null once every one of the 6236 ayahs is
/// covered by some [MemorizationUnit].
NextPassage? suggestNextPassage(
  QuranReferenceRepository reference,
  List<MemorizationUnit> existingUnits,
) {
  final coveredBySurah = <int, Set<int>>{};
  for (final unit in existingUnits) {
    final covered = coveredBySurah.putIfAbsent(unit.surahNumber, () => <int>{});
    for (var ayah = unit.startAyah; ayah <= unit.endAyah; ayah++) {
      covered.add(ayah);
    }
  }

  for (final surah in reference.surahs) {
    final covered = coveredBySurah[surah.number] ?? const <int>{};
    for (var ayah = 1; ayah <= surah.numberOfAyahs; ayah++) {
      if (covered.contains(ayah)) continue;
      var end = ayah;
      while (end < surah.numberOfAyahs && end - ayah + 1 < 3 && !covered.contains(end + 1)) {
        end++;
      }
      return NextPassage(surahNumber: surah.number, startAyah: ayah, endAyah: end);
    }
  }
  return null;
}
