import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/quran_reference/quran_reference_repository.dart';
import '../onboarding_draft.dart';

const _kTotalAyahs = 6236;

class DerivedProfileStep extends ConsumerWidget {
  const DerivedProfileStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final draft = ref.watch(onboardingDraftProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final surahCount = draft.memorizedSurahs.length;

    final memorizedAyahs = referenceAsync.value?.surahs
            .where((s) => draft.memorizedSurahs.contains(s.number))
            .fold<int>(0, (sum, s) => sum + s.numberOfAyahs) ??
        0;
    final percent = (memorizedAyahs / _kTotalAyahs * 100).round();

    final (icon, title, message) = switch (draft.derivedLevel) {
      OnboardingLevel.hafiz => (
          Icons.workspace_premium,
          'Mashallah, vous êtes Hafiz !',
          'Les 114 sourates sont marquées mémorisées. Wird vous aidera '
              'surtout à entretenir cette mémorisation dans la durée.',
        ),
      OnboardingLevel.enCours => (
          Icons.auto_stories,
          'Belle progression !',
          '$surahCount sourate${surahCount > 1 ? 's' : ''} déjà mémorisée'
              '${surahCount > 1 ? 's' : ''}, soit environ $percent % du Coran. '
              'Wird va vous aider à consolider ça et à continuer.',
        ),
      OnboardingLevel.debutant => (
          Icons.rocket_launch,
          'C\'est parti !',
          'Vous démarrez de zéro, et c\'est très bien ainsi — Wird vous '
              'accompagnera pas à pas, un verset à la fois.',
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(title, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
