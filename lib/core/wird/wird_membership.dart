import '../memorization/mastery.dart';

// Which sourates belong to the Wird and which are still in Révision — pure
// logic, no Flutter and no database.
//
// A sourate learned in the guided parcours stays in Révision until each of
// its verses has gone through every step of the spaced repetition (J+1, J+3,
// J+7, J+30) and is solid; then it moves to the Wird. Sourates declared as
// already memorized when joining have no verse of their own to schedule and
// are in the Wird from the start.

/// Successful reviews a verse needs before it is fixed: one per step of the
/// cycle — J+1, J+3, J+7 and J+30.
const reviewsToFix = 4;

/// What the review log says about one verse, oldest entry first.
typedef VerseLogEntry = ({String kind, String outcome});

/// How many reviews of a verse succeeded since it was last learned or
/// failed: the log is read in order and a new memorization or a "redo"
/// starts the count over, as the cycle itself does.
int successfulReviews(Iterable<VerseLogEntry> log) {
  var count = 0;
  for (final entry in log) {
    if (entry.kind == 'memorize' || entry.outcome == 'redo') {
      count = 0;
    } else if (entry.kind == 'review') {
      count++;
    }
  }
  return count;
}

/// Whether a verse has finished its cycle: every step done, and its last
/// self-assessment clean enough to count as solid.
bool isVerseFixed({
  required String? lastOutcome,
  required int cycleStep,
  required int successfulReviews,
}) =>
    successfulReviews >= reviewsToFix &&
    masteryFor(lastOutcome: lastOutcome, cycleStep: cycleStep) ==
        MasteryLevel.solid;

/// A verse learned in the parcours, as far as membership is concerned.
typedef VerseState = ({
  int surah,
  String? lastOutcome,
  int cycleStep,
  int successfulReviews,
});

/// The sourates in the Wird: every completed sourate whose own verses (if it
/// has any) are all fixed. [completedSurahs] are the sourates marked
/// complete — declared when joining, or fully learned since.
Set<int> wirdSurahs({
  required Iterable<int> completedSurahs,
  required Iterable<VerseState> verses,
}) {
  final bySurah = <int, List<VerseState>>{};
  for (final v in verses) {
    bySurah.putIfAbsent(v.surah, () => []).add(v);
  }
  return {
    for (final surah in completedSurahs)
      if ((bySurah[surah] ?? const []).every(
        (v) => isVerseFixed(
          lastOutcome: v.lastOutcome,
          cycleStep: v.cycleStep,
          successfulReviews: v.successfulReviews,
        ),
      ))
        surah,
  };
}
