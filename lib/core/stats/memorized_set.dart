import '../database/app_database.dart';

/// Every verse the user has memorized, as (surah, ayah) pairs.
///
/// Verses learned in the guided parcours have their own row; sourates
/// declared in the onboarding have none (a hafiz would mean thousands of
/// rows) and are simply complete — every one of their verses counts.
Set<({int surah, int ayah})> memorizedAyahSet(
  List<SurahProgressEntry> surahRows,
  List<AyahProgressEntry> ayahRows,
) => {
  for (final r in ayahRows) (surah: r.surahNumber, ayah: r.ayahNumber),
  for (final r in surahRows.where((r) => r.completedAt != null))
    for (var a = 1; a <= r.totalAyahCount; a++) (surah: r.surahNumber, ayah: a),
};
