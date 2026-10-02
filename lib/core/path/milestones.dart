/// Where a sourate stands on Le Chemin.
enum MilestoneState {
  /// Every verse memorized.
  completed,

  /// The sourate the next session works on — the first one not completed,
  /// the same one `suggestNextPassage` picks.
  current,

  /// Not reached yet.
  locked,
}

/// One milestone of Le Chemin: a sourate, in Mushaf order.
class Milestone {
  const Milestone({
    required this.surahNumber,
    required this.state,
    required this.memorizedAyahs,
    required this.totalAyahs,
    this.completedAt,
  });

  final int surahNumber;
  final MilestoneState state;
  final int memorizedAyahs;
  final int totalAyahs;
  final DateTime? completedAt;

  /// 0 to 1.
  double get progress => totalAyahs == 0 ? 0 : memorizedAyahs / totalAyahs;
}

/// One milestone per sourate. [ayahCounts] lists each sourate's number of
/// verses (index 0 = sourate 1); [progressBySurah] what is memorized, by
/// sourate number (absent = nothing yet).
///
/// A sourate is completed once all its verses are memorized; the first one
/// that isn't is the current milestone, and everything after it is still
/// ahead of the user (locked).
List<Milestone> buildMilestones({
  required List<int> ayahCounts,
  required Map<int, ({int memorized, DateTime? completedAt})> progressBySurah,
}) {
  var currentAssigned = false;
  return [
    for (var i = 0; i < ayahCounts.length; i++)
      () {
        final number = i + 1;
        final total = ayahCounts[i];
        final progress = progressBySurah[number];
        final memorized = (progress?.memorized ?? 0).clamp(0, total);
        final completed = total > 0 && memorized >= total;

        final MilestoneState state;
        if (completed) {
          state = MilestoneState.completed;
        } else if (!currentAssigned) {
          currentAssigned = true;
          state = MilestoneState.current;
        } else {
          state = MilestoneState.locked;
        }

        return Milestone(
          surahNumber: number,
          state: state,
          memorizedAyahs: memorized,
          totalAyahs: total,
          completedAt: completed ? progress?.completedAt : null,
        );
      }(),
  ];
}

/// How many milestones are completed.
int completedMilestones(List<Milestone> milestones) =>
    milestones.where((m) => m.state == MilestoneState.completed).length;

/// The milestone the next session works on; null once every sourate is done.
Milestone? currentMilestone(List<Milestone> milestones) {
  for (final m in milestones) {
    if (m.state == MilestoneState.current) return m;
  }
  return null;
}
