import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/memorization_repository.dart';
import '../../core/database/profile_repository.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/wird/wird_state.dart';
import 'onboarding_draft.dart';
import 'steps/availability_step.dart';
import 'steps/derived_profile_step.dart';
import 'steps/memorized_surahs_step.dart';
import 'steps/plan_summary_step.dart';
import 'steps/welcome_step.dart';
import 'steps/wird_goal_step.dart';

/// The Wird goal is only asked when some sourates are already memorized.
List<Widget> _stepsFor(OnboardingDraft draft) => [
  const WelcomeStep(),
  const MemorizedSurahsStep(),
  const DerivedProfileStep(),
  if (draft.memorizedSurahs.isNotEmpty) const WirdGoalStep(),
  const AvailabilityStep(),
  const PlanSummaryStep(),
];

/// Brique 2 : accueil, sélection des sourates déjà mémorisées (le niveau en
/// est dérivé, pas demandé), disponibilités, puis plan estimé. Flux linéaire
/// interne — pas de go_router, voir SudurApp pour le point d'entrée.
class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int _stepIndex = 0;
  bool _isSaving = false;


  Future<void> _finish() async {
    setState(() => _isSaving = true);
    final draft = ref.read(onboardingDraftProvider);
    final profile = await ref.read(currentProfileProvider.future);
    final reference = await ref.read(quranReferenceProvider.future);
    final memorization = ref.read(memorizationRepositoryProvider);
    final wirdAmount = draft.wirdAmount;
    if (draft.memorizedSurahs.isNotEmpty && wirdAmount != null) {
      await ref
          .read(wirdControllerProvider.notifier)
          .setGoal(draft.wirdUnit, wirdAmount);
    }

    for (final surahNumber in draft.memorizedSurahs) {
      await memorization.markSurahMemorized(
        profile.id,
        surahNumber,
        reference.surahByNumber(surahNumber).numberOfAyahs,
      );
    }

    await ref
        .read(userProfileRepositoryProvider)
        .updateProfile(
          id: profile.id,
          memorizationLevel: draft.derivedLevel.dbValue,
          availableDaysMask: draft.availableDaysMask,
          dailyTargetMinutes: draft.dailyTargetMinutes,
          hasCompletedOnboarding: true,
        );

    // Fait recalculer needsOnboardingProvider (qui dépend de ce profil) :
    // SudurApp bascule alors vers l'app normale.
    ref.invalidate(currentProfileProvider);
  }

  @override
  Widget build(BuildContext context) {
    final steps = _stepsFor(ref.watch(onboardingDraftProvider));
    final isLastStep = _stepIndex == steps.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_stepIndex + 1) / steps.length),
            Expanded(child: steps[_stepIndex]),
            Padding(
              padding: const EdgeInsets.all(16),
              // Side by side, or one above the other when the text is
              // enlarged enough that they would not both fit.
              child: OverflowBar(
                alignment: _stepIndex > 0
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                overflowAlignment: OverflowBarAlignment.end,
                overflowSpacing: 8,
                children: [
                  if (_stepIndex > 0)
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => setState(() => _stepIndex--),
                      child: const Text('Retour'),
                    ),
                  FilledButton(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            if (isLastStep) {
                              await _finish();
                            } else {
                              setState(() => _stepIndex++);
                            }
                          },
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isLastStep ? 'Terminer' : 'Suivant'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
