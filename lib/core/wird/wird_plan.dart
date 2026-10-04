import '../memorization/review_calendar.dart';

// The Wird: a daily share of the sourates already known, read round and
// round — pure logic, no Flutter and no database.

/// How the daily goal is counted.
enum WirdUnit { pages, juz }

/// Pages of the Mushaf in a Juz (604 pages over 30 Juz, rounded).
const pagesPerJuz = 20;

/// Largest daily goal offered, per unit.
const maxWirdPages = 60;
const maxWirdJuz = 10;

int maxWirdAmount(WirdUnit unit) =>
    unit == WirdUnit.pages ? maxWirdPages : maxWirdJuz;

/// The goal in pages of the Mushaf.
int wirdGoalPages(WirdUnit unit, int amount) =>
    unit == WirdUnit.pages ? amount : amount * pagesPerJuz;

/// A goal to propose before the user has chosen one: a loop of about a
/// month, in pages.
int suggestedWirdPages(int poolPages) =>
    (poolPages / 30).ceil().clamp(1, maxWirdPages);

/// Days for one full round at [goalPages] a day.
int daysToLoop(int poolPages, int goalPages) =>
    poolPages == 0 ? 0 : (poolPages / goalPages.clamp(1, 1 << 30)).ceil();

/// Today's share and where the loop stands.
class WirdPlan {
  const WirdPlan({
    required this.totalPages,
    required this.donePagesInTurn,
    required this.turn,
    required this.todayPages,
    required this.daysToLoop,
  });

  /// Pages in the loop.
  final int totalPages;

  /// Pages of the current round already read.
  final int donePagesInTurn;

  /// The round in progress, starting at 1.
  final int turn;

  /// The pages to read today, in order, without repeating one.
  final List<int> todayPages;

  /// Days one full round takes at the current goal.
  final int daysToLoop;

  double get fraction => totalPages == 0 ? 0 : donePagesInTurn / totalPages;
}

/// Today's share of the loop.
///
/// [pool] is the pages of the sourates in the Wird, in Mushaf order;
/// [pointer] the last page read (0 at the start of a round); [turnsDone] the
/// rounds completed so far. The share is the next [goalPages] pages after
/// the pointer; at the end of the loop it goes on from the first page.
WirdPlan planWird({
  required List<int> pool,
  required int pointer,
  required int turnsDone,
  required int goalPages,
}) {
  if (pool.isEmpty) {
    return WirdPlan(
      totalPages: 0,
      donePagesInTurn: 0,
      turn: turnsDone + 1,
      todayPages: const [],
      daysToLoop: 0,
    );
  }
  final start = _firstAfter(pool, pointer);
  final take = goalPages.clamp(1, pool.length);
  return WirdPlan(
    totalPages: pool.length,
    donePagesInTurn: pool.where((p) => p <= pointer).length,
    turn: turnsDone + 1,
    todayPages: [
      for (var i = 0; i < take; i++) pool[(start + i) % pool.length],
    ],
    daysToLoop: daysToLoop(pool.length, goalPages),
  );
}

/// Index of the first page of [pool] after [pointer]; 0 when the round is
/// over and the loop starts again.
int _firstAfter(List<int> pool, int pointer) {
  final i = pool.indexWhere((p) => p > pointer);
  return i < 0 ? 0 : i;
}

/// Where the loop stands once [portion] has been read.
({int pointer, int turnsDone}) advanceWird({
  required List<int> pool,
  required int pointer,
  required int turnsDone,
  required List<int> portion,
}) {
  if (portion.isEmpty || pool.isEmpty) {
    return (pointer: pointer, turnsDone: turnsDone);
  }
  var turns = turnsDone;
  var previous = pointer;
  for (final page in portion) {
    // A page not after the previous one means the loop came round.
    if (page <= previous && previous != 0) turns++;
    previous = page;
  }
  // Reaching the last page ends the round; the next one starts afresh.
  if (previous == pool.last) {
    return (pointer: 0, turnsDone: turns + 1);
  }
  return (pointer: previous, turnsDone: turns);
}

/// The pages a set of verses begin on, in order and without repetition.
List<int> wirdPoolPages({
  required Iterable<({int surah, int ayah})> ayahs,
  required Map<({int surah, int ayah}), int> pageByAyah,
}) {
  final pages = <int>{};
  for (final ayah in ayahs) {
    final page = pageByAyah[ayah];
    if (page != null) pages.add(page);
  }
  return pages.toList()..sort();
}

/// For each page of the loop, the first of [ayahs] that begins on it. A page
/// may open with the end of a sourate that is not in the Wird: this is the
/// verse the Wird's own reading starts from, and the sourate to name it by.
Map<int, ({int surah, int ayah})> firstWirdAyahByPage({
  required Iterable<({int surah, int ayah})> ayahs,
  required Map<({int surah, int ayah}), int> pageByAyah,
}) {
  final first = <int, ({int surah, int ayah})>{};
  for (final ayah in ayahs) {
    final page = pageByAyah[ayah];
    if (page == null) continue;
    final known = first[page];
    if (known == null ||
        ayah.surah < known.surah ||
        (ayah.surah == known.surah && ayah.ayah < known.ayah)) {
      first[page] = ayah;
    }
  }
  return first;
}

/// Whether [a] and [b] are the same calendar day.
bool sameDay(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);
