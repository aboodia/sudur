import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/memorization_repository.dart';
import '../../core/database/review_repository.dart';
import '../../core/review/spaced_repetition.dart';

/// Une session de révision (murâja'a, Brique 4) fait défiler la file
/// d'unités dues du jour, un passage à la fois : rappel de mémoire →
/// dévoilement → auto-évaluation (Faible/Moyen/Solide).
enum ReviewStage { recalling, revealed, complete }

class ReviewSessionState {
  const ReviewSessionState({
    this.units,
    this.currentIndex = 0,
    this.stage = ReviewStage.recalling,
  });

  /// Null until [ReviewSessionController.startSession] runs — distinct from
  /// an empty list, which means the queue loaded but nothing is due.
  final List<MemorizationUnit>? units;
  final int currentIndex;
  final ReviewStage stage;

  bool get isLoaded => units != null;

  MemorizationUnit? get currentUnit {
    final list = units;
    if (list == null || currentIndex >= list.length) return null;
    return list[currentIndex];
  }

  ReviewSessionState copyWith({
    List<MemorizationUnit>? units,
    int? currentIndex,
    ReviewStage? stage,
  }) =>
      ReviewSessionState(
        units: units ?? this.units,
        currentIndex: currentIndex ?? this.currentIndex,
        stage: stage ?? this.stage,
      );
}

/// Découplé de l'audio comme `MemorizationSessionController` — l'écran
/// déclenche lui-même `audioPlaybackProvider` pour l'écoute.
class ReviewSessionController extends Notifier<ReviewSessionState> {
  @override
  ReviewSessionState build() => const ReviewSessionState();

  void startSession(List<MemorizationUnit> units) {
    state = ReviewSessionState(units: units);
  }

  void reveal() {
    state = state.copyWith(stage: ReviewStage.revealed);
  }

  Future<void> rate(ReviewRating rating) async {
    final unit = state.currentUnit;
    if (unit == null) return;
    await ref.read(reviewRepositoryProvider).recordReview(unit.id, rating);
    ref.invalidate(dueUnitsProvider);
    ref.invalidate(memorizationUnitsProvider);

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < state.units!.length) {
      state = state.copyWith(currentIndex: nextIndex, stage: ReviewStage.recalling);
    } else {
      state = state.copyWith(stage: ReviewStage.complete);
    }
  }
}

final reviewSessionProvider = NotifierProvider<ReviewSessionController, ReviewSessionState>(
  ReviewSessionController.new,
);
