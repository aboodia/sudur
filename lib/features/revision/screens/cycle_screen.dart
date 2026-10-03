import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/memorization_repository.dart';
import '../../../core/database/profile_repository.dart';
import '../../../core/memorization/review_scheduler.dart';
import '../../../core/memorization/study_session.dart';
import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/revision/review_cycle.dart';
import '../../../core/revision/review_cycle_provider.dart';
import '../../../core/stats/progress_history_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../memorization/widgets/outcome_tile.dart';

/// Révision du Coran: today's share of what the user already knew when they
/// joined, page by page, and how they got on with it.
class CycleScreen extends ConsumerStatefulWidget {
  const CycleScreen({super.key});

  @override
  ConsumerState<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends ConsumerState<CycleScreen> {
  ReciteOutcome? _outcome;
  late final DateTime _openedAt = DateTime.now();
  var _saving = false;

  Future<void> _finish(CycleToday today) async {
    final outcome = _outcome;
    if (outcome == null || _saving) return;
    setState(() => _saving = true);

    final profile = await ref.read(currentProfileProvider.future);
    final mushaf = await ref.read(mushafRepositoryProvider.future);
    final declared = await ref.read(declaredAyahsProvider.future);
    final repo = ref.read(memorizationRepositoryProvider);
    final pages = today.plan.todayPages.toSet();
    final byPage = mushaf.firstPageByAyah();

    final first = mushaf.firstAyahOnPage(today.plan.todayPages.first);
    if (first != null) {
      await repo.logCycleReview(
        profileId: profile.id,
        surahNumber: first.surah,
        ayahNumber: first.ayah,
        outcome: outcome,
      );
    }
    await repo.logStudySession(
      profileId: profile.id,
      kind: 'revision',
      startedAt: _openedAt,
      duration: cappedStudyDuration(DateTime.now().difference(_openedAt)),
      ayahCount: declared.where((a) => pages.contains(byPage[a])).length,
    );
    // A share to redo is not counted: it comes back until it is done.
    if (outcome != ReciteOutcome.redo) {
      await ref
          .read(reviewCycleProvider.notifier)
          .completePages(today.plan.todayPages.length, DateTime.now());
    }
    ref.invalidate(cycleTodayProvider);
    refreshProgressData(ref.invalidate);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _outcome = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayAsync = ref.watch(cycleTodayProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cycleTitle)),
      body: SafeArea(
        child: todayAsync.when(
          data: (today) {
            if (today == null) return const SizedBox.shrink();
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Progress(today: today),
                const SizedBox(height: 16),
                if (today.doneToday)
                  _DoneCard(finished: today.plan.finished)
                else
                  _Share(
                    today: today,
                    outcome: _outcome,
                    saving: _saving,
                    onOutcome: (o) => setState(() => _outcome = o),
                    onFinish: () => _finish(today),
                  ),
                const SizedBox(height: 24),
                _LengthPicker(days: today.days),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erreur : $err')),
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.today});

  final CycleToday today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plan = today.plan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.cycleIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: plan.fraction, minHeight: 10),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.cycleProgress(plan.donePages, plan.totalPages, plan.daysLeft),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.finished});

  final bool finished;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (finished) ...[
            Text(l10n.cycleFinishedTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(l10n.cycleFinishedBody, style: theme.textTheme.bodyMedium),
          ] else
            Text(l10n.cycleDoneToday, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _Share extends ConsumerWidget {
  const _Share({
    required this.today,
    required this.outcome,
    required this.saving,
    required this.onOutcome,
    required this.onFinish,
  });

  final CycleToday today;
  final ReciteOutcome? outcome;
  final bool saving;
  final ValueChanged<ReciteOutcome> onOutcome;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mushaf = ref.watch(mushafRepositoryProvider).value;
    final reference = ref.watch(quranReferenceProvider).value;
    final pages = today.plan.todayPages;

    String surahOf(int page) {
      final first = mushaf?.firstAyahOnPage(page);
      if (first == null || reference == null) return '';
      return reference.surahByNumber(first.surah).englishName;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.cycleTodayCount(pages.length),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final page in pages)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(l10n.cyclePageIn(page, surahOf(page))),
              trailing: const Icon(Icons.menu_book_outlined),
              onTap: () => context.push('/lecture/mushaf?page=$page'),
            ),
          ),
        const SizedBox(height: 16),
        Text(l10n.cycleHow, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        OutcomeTile(
          title: l10n.outcomeClean,
          subtitle: l10n.cycleOutcomeCleanSub,
          selected: outcome == ReciteOutcome.clean,
          onTap: () => onOutcome(ReciteOutcome.clean),
        ),
        OutcomeTile(
          title: l10n.outcomeHesitant,
          subtitle: l10n.cycleOutcomeHesitantSub,
          selected: outcome == ReciteOutcome.hesitant,
          onTap: () => onOutcome(ReciteOutcome.hesitant),
        ),
        OutcomeTile(
          title: l10n.outcomeRedo,
          subtitle: l10n.cycleOutcomeRedoSub,
          selected: outcome == ReciteOutcome.redo,
          onTap: () => onOutcome(ReciteOutcome.redo),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: outcome == null || saving ? null : onFinish,
          child: Text(l10n.cycleFinish),
        ),
      ],
    );
  }
}

class _LengthPicker extends ConsumerWidget {
  const _LengthPicker({required this.days});

  final int days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.cycleLength, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final choice in cycleLengthChoices)
              ChoiceChip(
                label: Text(l10n.cycleLengthDays(choice)),
                selected: days == choice,
                onSelected: (_) =>
                    ref.read(reviewCycleProvider.notifier).setDays(choice),
              ),
          ],
        ),
      ],
    );
  }
}
