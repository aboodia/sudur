import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/memorization_repository.dart';
import '../quran_reference/quran_reference_repository.dart';
import 'milestones.dart';

/// Le Chemin: one milestone per sourate, from what is actually memorized.
final milestonesProvider = FutureProvider<List<Milestone>>((ref) async {
  final reference = await ref.watch(quranReferenceProvider.future);
  final rows = await ref.watch(surahProgressProvider.future);

  return buildMilestones(
    ayahCounts: [for (final s in reference.surahs) s.numberOfAyahs],
    progressBySurah: {
      for (final r in rows)
        r.surahNumber: (
          memorized: r.memorizedAyahCount,
          completedAt: r.completedAt,
        ),
    },
  );
});
