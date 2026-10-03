import 'step_scroll.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/quran_reference/quran_reference_repository.dart';
import '../onboarding_draft.dart';

const _kTotalAyahs = 6236;

/// Estimation volontairement grossière (une seule constante) — la Brique 4
/// (répétition espacée SM-2) affinera le rythme avec de vraies données.
const _kMinutesPerNewAyah = 3;

int _popcount(int mask) {
  var count = 0;
  for (var bit = 0; bit < 7; bit++) {
    if ((mask & (1 << bit)) != 0) count++;
  }
  return count;
}

class PlanSummaryStep extends ConsumerWidget {
  const PlanSummaryStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final draft = ref.watch(onboardingDraftProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);

    final memorizedAyahs =
        referenceAsync.value?.surahs
            .where((s) => draft.memorizedSurahs.contains(s.number))
            .fold<int>(0, (sum, s) => sum + s.numberOfAyahs) ??
        0;
    final remainingAyahs = _kTotalAyahs - memorizedAyahs;

    Widget content;
    if (remainingAyahs <= 0) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Le Coran est déjà entièrement mémorisé — place à l\'entretien '
            'et à la révision plutôt qu\'à un nouveau rythme d\'apprentissage.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      final activeDaysPerWeek = _popcount(draft.availableDaysMask);
      final ayahsPerActiveDay = (draft.dailyTargetMinutes / _kMinutesPerNewAyah)
          .clamp(1, double.infinity);
      final weeksEstimate = activeDaysPerWeek > 0
          ? (remainingAyahs / (ayahsPerActiveDay * activeDaysPerWeek)).ceil()
          : null;

      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Votre plan estimé', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text('$remainingAyahs versets restants à mémoriser.'),
          const SizedBox(height: 4),
          Text(
            '${draft.dailyTargetMinutes} min/jour, $activeDaysPerWeek jour'
            '${activeDaysPerWeek > 1 ? 's' : ''}/semaine.',
          ),
          const SizedBox(height: 12),
          if (weeksEstimate != null)
            Text(
              'À ce rythme, environ $weeksEstimate semaine${weeksEstimate > 1 ? 's' : ''} '
              'pour terminer la mémorisation du Coran.',
              style: theme.textTheme.bodyLarge,
            )
          else
            Text(
              'Choisissez au moins un jour disponible pour obtenir une estimation.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Estimation grossière, affinée automatiquement au fil de vos '
            'révisions.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return StepScroll(
      child: Padding(padding: const EdgeInsets.all(24), child: content),
    );
  }
}
