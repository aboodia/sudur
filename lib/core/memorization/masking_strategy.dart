import 'dart:math';

/// The 3 masking levels of the "Masquer" step — Léger hides ~25% of words
/// (skipping short ones so the exercise stays meaningful), Moyen ~60%,
/// Complet hides everything but the first word (which stays as a memory
/// anchor, per the "Réciter" mockup).
enum MaskLevel { light, medium, full }

/// Which word indices are hidden for a given verse + level — deterministic
/// (same `words`/`level`/`seed` always give the same result, e.g. the seed
/// is derived from the ayah's identity), so leaving and reopening a session
/// shows the exact same masking pattern instead of a new random one.
List<int> maskedIndices(List<String> words, MaskLevel level, int seed) {
  if (words.isEmpty) return const [];

  if (level == MaskLevel.full) {
    return [for (var i = 1; i < words.length; i++) i];
  }

  final ratio = level == MaskLevel.light ? 0.25 : 0.6;
  final eligible = level == MaskLevel.light
      ? [
          for (var i = 0; i < words.length; i++)
            if (words[i].length > 2) i,
        ]
      : [for (var i = 0; i < words.length; i++) i];

  if (eligible.isEmpty) return const [];

  final targetCount = (words.length * ratio).round().clamp(0, eligible.length);
  if (targetCount == 0) return const [];

  // A fresh seeded Random per index (rather than one Random().shuffle over
  // the whole list) keeps the ranking stable regardless of Dart's shuffle
  // algorithm — the same (seed, index) pair always draws the same score.
  final scored = [
    for (final index in eligible)
      (index: index, score: Random(seed + index).nextDouble()),
  ]..sort((a, b) => a.score.compareTo(b.score));

  final chosen = scored.take(targetCount).map((entry) => entry.index).toList()
    ..sort();
  return chosen;
}
