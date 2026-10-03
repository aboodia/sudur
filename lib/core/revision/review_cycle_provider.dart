import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/memorization_repository.dart';
import '../memorization/review_calendar.dart';
import '../mushaf/mushaf_repository.dart';
import 'review_cycle.dart';

/// Where the user stands in the revision cycle.
class ReviewCycleState {
  const ReviewCycleState({
    this.loaded = false,
    this.days = defaultCycleDays,
    this.start,
    this.donePages = 0,
    this.lastDoneDay,
  });

  final bool loaded;
  final int days;

  /// The day the cycle began; null before the first need for it.
  final DateTime? start;

  /// Pages reviewed so far in this cycle.
  final int donePages;

  /// The last day a share was reviewed.
  final DateTime? lastDoneDay;

  ReviewCycleState copyWith({
    int? days,
    DateTime? start,
    int? donePages,
    DateTime? lastDoneDay,
  }) => ReviewCycleState(
    loaded: true,
    days: days ?? this.days,
    start: start ?? this.start,
    donePages: donePages ?? this.donePages,
    lastDoneDay: lastDoneDay ?? this.lastDoneDay,
  );
}

const _kDays = 'cycle.days';
const _kStart = 'cycle.start';
const _kDone = 'cycle.done';
const _kLastDone = 'cycle.lastDone';

String _dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

DateTime? _parseDay(String? s) {
  if (s == null) return null;
  final parts = s.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

class ReviewCycleController extends Notifier<ReviewCycleState> {
  @override
  ReviewCycleState build() {
    _restore();
    return const ReviewCycleState();
  }

  Future<void> _restore() async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Storage unavailable: the cycle starts from its defaults.
    }
    if (!ref.mounted) return;
    final days = prefs?.getInt(_kDays);
    state = ReviewCycleState(
      loaded: true,
      days: cycleLengthChoices.contains(days) ? days! : defaultCycleDays,
      start: _parseDay(prefs?.getString(_kStart)),
      donePages: prefs?.getInt(_kDone) ?? 0,
      lastDoneDay: _parseDay(prefs?.getString(_kLastDone)),
    );
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kDays, state.days);
    await prefs.setInt(_kDone, state.donePages);
    if (state.start != null) {
      await prefs.setString(_kStart, _dayKey(state.start!));
    }
    if (state.lastDoneDay != null) {
      await prefs.setString(_kLastDone, _dayKey(state.lastDoneDay!));
    }
  }

  /// Starts a new cycle today, from the first page.
  Future<void> restart(DateTime today) async {
    state = ReviewCycleState(
      loaded: true,
      days: state.days,
      start: dateOnly(today),
      donePages: 0,
      lastDoneDay: state.lastDoneDay,
    );
    await _save();
  }

  /// Changes the length of the running cycle.
  Future<void> setDays(int days) async {
    if (!cycleLengthChoices.contains(days)) return;
    state = state.copyWith(days: days);
    await _save();
  }

  /// [count] more pages of the cycle were reviewed today.
  Future<void> completePages(int count, DateTime today) async {
    state = state.copyWith(
      donePages: state.donePages + count,
      lastDoneDay: dateOnly(today),
    );
    await _save();
  }
}

final reviewCycleProvider =
    NotifierProvider<ReviewCycleController, ReviewCycleState>(
      ReviewCycleController.new,
    );

/// The verses declared as already memorized — sourates with no verse of
/// their own in the guided parcours (those are scheduled verse by verse).
final declaredAyahsProvider = FutureProvider<List<({int surah, int ayah})>>((
  ref,
) async {
  final surahRows = await ref.watch(surahProgressProvider.future);
  final ayahRows = await ref.watch(ayahProgressProvider.future);
  final withVerseRows = {for (final r in ayahRows) r.surahNumber};
  return [
    for (final r in surahRows)
      if (r.completedAt != null && !withVerseRows.contains(r.surahNumber))
        for (var a = 1; a <= r.totalAyahCount; a++)
          (surah: r.surahNumber, ayah: a),
  ];
});

/// The Mushaf pages of the declared verses, in order: the cycle's pool.
final cyclePoolProvider = FutureProvider<List<int>>((ref) async {
  final declared = await ref.watch(declaredAyahsProvider.future);
  if (declared.isEmpty) return const [];
  final mushaf = await ref.watch(mushafRepositoryProvider.future);
  return poolPages(
    declaredAyahs: declared,
    pageByAyah: mushaf.firstPageByAyah(),
  );
});

/// Today's share of the cycle, with whether it is already done.
class CycleToday {
  const CycleToday({
    required this.plan,
    required this.doneToday,
    required this.days,
  });

  final CyclePlan plan;
  final bool doneToday;
  final int days;
}

/// Null when the user declared nothing to review (the cycle does not apply).
final cycleTodayProvider = FutureProvider<CycleToday?>((ref) async {
  final pool = await ref.watch(cyclePoolProvider.future);
  if (pool.isEmpty) return null;
  final cycle = ref.watch(reviewCycleProvider);
  if (!cycle.loaded) return null;

  final today = dateOnly(DateTime.now());
  final controller = ref.read(reviewCycleProvider.notifier);

  var start = cycle.start;
  if (start == null) {
    // First time: the cycle begins today.
    Future.microtask(() => controller.restart(today));
    start = today;
  }
  var plan = planCycleDay(
    pool: pool,
    donePages: cycle.donePages,
    cycleDays: cycle.days,
    start: start,
    today: today,
  );
  final doneToday = cycle.lastDoneDay == today;
  if (plan.finished && !doneToday) {
    // A finished cycle rolls into the next one on a new day.
    Future.microtask(() => controller.restart(today));
    plan = planCycleDay(
      pool: pool,
      donePages: 0,
      cycleDays: cycle.days,
      start: today,
      today: today,
    );
  }
  return CycleToday(plan: plan, doneToday: doneToday, days: cycle.days);
});
