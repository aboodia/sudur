import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/memorization_repository.dart';
import '../../core/database/profile_repository.dart';
import '../../core/memorization/review_calendar.dart';
import '../../core/memorization/review_scheduler.dart';
import '../../core/memorization/study_session.dart';
import '../../core/stats/progress_history_provider.dart';

/// Most verses one revision session offers — "sessions courtes (5-15 min)"
/// per the cahier des charges. Whatever is left stays due and is offered by
/// the next session ("Réviser encore").
const revisionSessionSize = 10;

class RevisionSessionState {
  const RevisionSessionState({
    this.isLoaded = false,
    this.items = const [],
    this.index = 0,
    this.results = const [],
    this.remainingDue = 0,
    this.nextReviewDay,
    this.isFinished = false,
  });

  final bool isLoaded;

  /// This session's verses, in Mushaf order.
  final List<AyahProgressEntry> items;
  final int index;
  final List<ReciteOutcome> results;

  /// Verses still due today that this session didn't take (see
  /// [revisionSessionSize]) — known once the session is finished.
  final int remainingDue;

  /// Day of the next review after this session, if anything is scheduled.
  final DateTime? nextReviewDay;

  final bool isFinished;

  /// Nothing was due when the session opened.
  bool get isEmpty => isLoaded && items.isEmpty;

  AyahProgressEntry? get current =>
      isLoaded && index < items.length ? items[index] : null;

  int count(ReciteOutcome outcome) => results.where((r) => r == outcome).length;

  RevisionSessionState copyWith({
    bool? isLoaded,
    List<AyahProgressEntry>? items,
    int? index,
    List<ReciteOutcome>? results,
    int? remainingDue,
    DateTime? nextReviewDay,
    bool? isFinished,
  }) => RevisionSessionState(
    isLoaded: isLoaded ?? this.isLoaded,
    items: items ?? this.items,
    index: index ?? this.index,
    results: results ?? this.results,
    remainingDue: remainingDue ?? this.remainingDue,
    nextReviewDay: nextReviewDay ?? this.nextReviewDay,
    isFinished: isFinished ?? this.isFinished,
  );
}

/// Drives one revision session: the verses due today, one at a time, each
/// rated with the same three-way self-assessment as "Réciter". Every rating
/// is saved immediately, so quitting midway loses nothing — the verses not
/// yet reviewed simply stay due.
class RevisionSessionController extends Notifier<RevisionSessionState> {
  DateTime _startedAt = DateTime.now();

  @override
  RevisionSessionState build() => const RevisionSessionState();

  Future<void> start() async {
    final profile = await ref.read(currentProfileProvider.future);
    final repo = ref.read(memorizationRepositoryProvider);

    // Oldest due first, so the most overdue verses are never the ones left
    // out by the cap — then back in Mushaf order, so consecutive verses are
    // recited one after the other.
    final due = await repo.dueReviews(profile.id);
    final items = due.take(revisionSessionSize).toList()
      ..sort((a, b) {
        final bySurah = a.surahNumber.compareTo(b.surahNumber);
        return bySurah != 0 ? bySurah : a.ayahNumber.compareTo(b.ayahNumber);
      });

    _startedAt = DateTime.now();
    state = RevisionSessionState(isLoaded: true, items: items);
  }

  /// Records the self-assessment for the current verse and moves on — or
  /// finishes the session after the last one.
  Future<void> submit(ReciteOutcome outcome) async {
    final entry = state.current;
    if (entry == null) return;

    final repo = ref.read(memorizationRepositoryProvider);
    await repo.recordAyahReview(
      ayahProgressId: entry.id,
      outcome: outcome,
      hasFragileWords: _hasFragileWords(entry),
    );
    refreshProgressData(ref.invalidate);

    final results = [...state.results, outcome];
    final next = state.index + 1;
    if (next < state.items.length) {
      state = state.copyWith(index: next, results: results);
      return;
    }
    await _finish(results);
  }

  Future<void> _finish(List<ReciteOutcome> results) async {
    final profile = await ref.read(currentProfileProvider.future);
    final repo = ref.read(memorizationRepositoryProvider);
    final now = DateTime.now();

    await repo.logStudySession(
      profileId: profile.id,
      kind: 'revision',
      startedAt: _startedAt,
      duration: cappedStudyDuration(now.difference(_startedAt)),
      ayahCount: results.length,
    );

    final remaining = (await repo.dueReviews(profile.id)).length;
    final today = dateOnly(now);
    final upcoming =
        (await repo.allAyahProgress(profile.id))
            .map((e) => dateOnly(e.nextReviewAt))
            .where((d) => d.isAfter(today))
            .toList()
          ..sort();

    ref.invalidate(dueReviewsProvider);
    ref.invalidate(ayahProgressProvider);

    state = state.copyWith(
      results: results,
      remainingDue: remaining,
      nextReviewDay: upcoming.isEmpty ? null : upcoming.first,
      isFinished: true,
    );
  }

  static bool _hasFragileWords(AyahProgressEntry entry) {
    try {
      final decoded = jsonDecode(entry.fragileWordIndices);
      return decoded is List && decoded.isNotEmpty;
    } on FormatException {
      return false;
    }
  }
}

/// Auto-disposed: each visit to the session screen starts from a clean
/// state instead of flashing the previous session's summary.
final revisionSessionProvider =
    NotifierProvider.autoDispose<
      RevisionSessionController,
      RevisionSessionState
    >(RevisionSessionController.new);
