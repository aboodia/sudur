import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 'debutant' | 'en_cours' | 'hafiz' — mirrors [UserProfiles.memorizationLevel]
/// in core/database/tables.dart, derived (not asked) from how many sourates
/// the Onboarding selection step marked as already memorized.
enum OnboardingLevel { debutant, enCours, hafiz }

extension OnboardingLevelDbValue on OnboardingLevel {
  String get dbValue => switch (this) {
        OnboardingLevel.debutant => 'debutant',
        OnboardingLevel.enCours => 'en_cours',
        OnboardingLevel.hafiz => 'hafiz',
      };
}

/// Local, not-yet-persisted state collected across the Onboarding steps —
/// only written to the profile (via UserProfileRepository.updateProfile and
/// MemorizationRepository.markSurahMemorized) once the final step confirms.
class OnboardingDraft {
  const OnboardingDraft({
    this.memorizedSurahs = const {},
    this.availableDaysMask = 127,
    this.dailyTargetMinutes = 10,
  });

  final Set<int> memorizedSurahs;
  final int availableDaysMask;
  final int dailyTargetMinutes;

  /// Hafiz iff every one of the 114 sourates is marked memorized — anything
  /// less is "en_cours", zero is "debutant".
  OnboardingLevel get derivedLevel {
    if (memorizedSurahs.length >= 114) return OnboardingLevel.hafiz;
    if (memorizedSurahs.isNotEmpty) return OnboardingLevel.enCours;
    return OnboardingLevel.debutant;
  }

  OnboardingDraft copyWith({
    Set<int>? memorizedSurahs,
    int? availableDaysMask,
    int? dailyTargetMinutes,
  }) =>
      OnboardingDraft(
        memorizedSurahs: memorizedSurahs ?? this.memorizedSurahs,
        availableDaysMask: availableDaysMask ?? this.availableDaysMask,
        dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
      );
}

class OnboardingDraftController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  void toggleSurah(int surahNumber) {
    final next = Set<int>.of(state.memorizedSurahs);
    if (!next.add(surahNumber)) next.remove(surahNumber);
    state = state.copyWith(memorizedSurahs: next);
  }

  void selectAllSurahs(Iterable<int> allSurahNumbers) {
    state = state.copyWith(memorizedSurahs: Set<int>.of(allSurahNumbers));
  }

  void deselectAllSurahs() {
    state = state.copyWith(memorizedSurahs: const {});
  }

  void toggleDay(int dayBitIndex) {
    state = state.copyWith(availableDaysMask: state.availableDaysMask ^ (1 << dayBitIndex));
  }

  void setDailyTargetMinutes(int minutes) {
    state = state.copyWith(dailyTargetMinutes: minutes);
  }
}

final onboardingDraftProvider =
    NotifierProvider<OnboardingDraftController, OnboardingDraft>(OnboardingDraftController.new);
