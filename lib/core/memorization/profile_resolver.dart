import '../gamification/memorizer_profile.dart';

/// The badge one tier above [this], or null for [MemorizerBadge.hafiz]
/// (already the last one).
extension ProfileResolver on MemorizerBadge {
  MemorizerBadge? get next {
    final values = MemorizerBadge.values;
    final index = values.indexOf(this) + 1;
    return index < values.length ? values[index] : null;
  }
}

/// How many more fully-memorized sourates until the next badge — 0 once
/// [MemorizerBadge.hafiz] is reached (nothing further to aim for).
int surahsToNextBadge(int memorizedSurahCount) {
  final next = memorizerBadgeForCount(memorizedSurahCount).next;
  if (next == null) return 0;
  return next.info.minSurahs - memorizedSurahCount;
}
