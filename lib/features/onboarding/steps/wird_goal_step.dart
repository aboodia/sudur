import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/wird/wird_plan.dart';
import '../../../l10n/app_localizations.dart';
import '../../wird/widgets/wird_goal_editor.dart';
import '../onboarding_draft.dart';
import 'step_scroll.dart';

/// Pages of the Mushaf the sourates declared so far would make up in the
/// Wird.
final _declaredPoolProvider = FutureProvider.autoDispose<List<int>>((
  ref,
) async {
  final surahs = ref.watch(
    onboardingDraftProvider.select((d) => d.memorizedSurahs),
  );
  final reference = await ref.watch(quranReferenceProvider.future);
  final mushaf = await ref.watch(mushafRepositoryProvider.future);
  return wirdPoolPages(
    ayahs: [
      for (final n in surahs)
        for (var a = 1; a <= reference.surahByNumber(n).numberOfAyahs; a++)
          (surah: n, ayah: a),
    ],
    pageByAyah: mushaf.firstPageByAyah(),
  );
});

/// "Ton Wird": how much of what is already known to read each day — only
/// asked when some of the Quran is already memorized.
class WirdGoalStep extends ConsumerWidget {
  const WirdGoalStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final draft = ref.watch(onboardingDraftProvider);
    final pool = ref.watch(_declaredPoolProvider).value ?? const <int>[];

    final amount =
        draft.wirdAmount ??
        (pool.isEmpty ? 1 : suggestedWirdPages(pool.length));
    final unit = draft.wirdAmount == null ? WirdUnit.pages : draft.wirdUnit;

    return StepScroll(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.wirdOnboardTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(l10n.wirdOnboardBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            WirdGoalEditor(
              unit: unit,
              amount: amount,
              onChanged: (u, a) =>
                  ref.read(onboardingDraftProvider.notifier).setWirdGoal(u, a),
            ),
            if (pool.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.wirdLoopIn(
                  daysToLoop(pool.length, wirdGoalPages(unit, amount)),
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (draft.wirdAmount == null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.wirdGoalSuggested,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
