import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_draft.dart';
import 'step_scroll.dart';

const _kDayLabels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
const _kDurationOptions = [5, 10, 15, 20, 30, 45, 60];

class AvailabilityStep extends ConsumerWidget {
  const AvailabilityStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final draft = ref.watch(onboardingDraftProvider);
    final controller = ref.read(onboardingDraftProvider.notifier);

    return StepScroll(
      center: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quels jours pouvez-vous vous consacrer à Sudur ?',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var day = 0; day < 7; day++)
                  FilterChip(
                    label: Text(_kDayLabels[day]),
                    selected: (draft.availableDaysMask & (1 << day)) != 0,
                    onSelected: (_) => controller.toggleDay(day),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Combien de temps par jour ?',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final minutes in _kDurationOptions)
                  ChoiceChip(
                    label: Text('$minutes min'),
                    selected: draft.dailyTargetMinutes == minutes,
                    onSelected: (_) =>
                        controller.setDailyTargetMinutes(minutes),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
