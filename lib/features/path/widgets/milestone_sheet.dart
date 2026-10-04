import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/memorization_repository.dart';
import '../../../core/format/french_date.dart';
import '../../../core/memorization/mastery.dart';
import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/path/milestones.dart';
import '../../../core/path/surah_stories.dart';
import '../../../core/quran_reference/quran_reference_models.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../revision/widgets/mastery_widgets.dart';
import 'surah_story_sheet.dart';

String revelationLabel(AppLocalizations l10n, Surah surah) =>
    surah.revelationType == RevelationType.meccan
    ? l10n.revelationMeccan
    : l10n.revelationMedinan;

/// The detail of one milestone: where the sourate stands, what to do next,
/// and — once completed — its mastery and its unlocked story.
Future<void> showMilestoneSheet(BuildContext context, Milestone milestone) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: _MilestoneSheet(milestone: milestone),
      ),
    ),
  );
}

class _MilestoneSheet extends ConsumerWidget {
  const _MilestoneSheet({required this.milestone});

  final Milestone milestone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final surah = ref
        .watch(quranReferenceProvider)
        .value
        ?.surahByNumber(milestone.surahNumber);
    if (surah == null) return const SizedBox.shrink();

    final entries = (ref.watch(ayahProgressProvider).value ?? const [])
        .where((e) => e.surahNumber == milestone.surahNumber)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                surah.englishName,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            Text(
              surah.nameArabic,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 26),
            ),
          ],
        ),
        Text(
          l10n.milestoneVersesAndType(
            surah.numberOfAyahs,
            revelationLabel(l10n, surah),
          ),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        switch (milestone.state) {
          MilestoneState.completed => _CompletedBody(
            milestone: milestone,
            surah: surah,
            levels: [
              for (final e in entries)
                masteryFor(
                  lastOutcome: e.lastOutcome,
                  cycleStep: e.reviewCycleStep,
                ),
            ],
          ),
          MilestoneState.current => _CurrentBody(milestone: milestone),
          MilestoneState.locked => Text(
            l10n.milestoneLocksHint,
            style: theme.textTheme.bodyMedium,
          ),
        },
      ],
    );
  }
}

class _CompletedBody extends ConsumerWidget {
  const _CompletedBody({
    required this.milestone,
    required this.surah,
    required this.levels,
  });

  final Milestone milestone;
  final Surah surah;
  final List<MasteryLevel> levels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final completedAt = milestone.completedAt;
    final counts = MasteryCounts.of(levels);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sourates declared in the onboarding have no per-verse history, so
        // their "completion date" would only be the day of sign-up.
        Text(
          levels.isEmpty || completedAt == null
              ? l10n.milestoneAlreadyKnown
              : l10n.milestoneCompletedOn(frenchFullDate(completedAt)),
          style: theme.textTheme.bodyLarge,
        ),
        if (counts.total > 0) ...[
          const SizedBox(height: 12),
          MasteryBar(counts: counts, height: 10),
          const SizedBox(height: 6),
          MasteryLegend(counts: counts),
        ],
        // The story only when there is one: no empty placeholder repeated
        // on every sourate.
        if (ref.watch(hasStoryProvider(surah.number))) ...[
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          SurahStoryContent(
            surahNumber: surah.number,
            surahName: surah.englishName,
          ),
        ],
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () async {
            final mushaf = await ref.read(mushafRepositoryProvider.future);
            final page = mushaf.pageForAyah(surah.number, 1) ?? 1;
            if (!context.mounted) return;
            Navigator.of(context).pop();
            context.push('/lecture/mushaf?page=$page');
          },
          child: Text(l10n.milestoneRead),
        ),
      ],
    );
  }
}

class _CurrentBody extends StatelessWidget {
  const _CurrentBody({required this.milestone});

  final Milestone milestone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.surahProgressCount(
            milestone.memorizedAyahs,
            milestone.totalAyahs,
          ),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: milestone.progress,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.push('/memoriser');
          },
          child: Text(l10n.milestoneContinue),
        ),
      ],
    );
  }
}
