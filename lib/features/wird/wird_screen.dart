import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/memorization_repository.dart';
import '../../core/database/profile_repository.dart';
import '../../core/memorization/review_scheduler.dart';
import '../../core/memorization/study_session.dart';
import '../../core/mushaf/mushaf_repository.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/stats/progress_history_provider.dart';
import '../../core/wird/wird_plan.dart';
import '../../core/wird/wird_providers.dart';
import '../../core/wird/wird_state.dart';
import '../../l10n/app_localizations.dart';
import '../memorization/widgets/outcome_tile.dart';
import 'widgets/wird_goal_editor.dart';

/// Le Wird: today's share of the sourates already known, page by page, in a
/// loop, and how the reading went.
class WirdScreen extends ConsumerStatefulWidget {
  const WirdScreen({super.key});

  @override
  ConsumerState<WirdScreen> createState() => _WirdScreenState();
}

class _WirdScreenState extends ConsumerState<WirdScreen> {
  ReciteOutcome? _outcome;
  late final DateTime _openedAt = DateTime.now();
  var _saving = false;

  Future<void> _finish(WirdToday today) async {
    final outcome = _outcome;
    if (outcome == null || _saving) return;
    setState(() => _saving = true);

    final profile = await ref.read(currentProfileProvider.future);
    final mushaf = await ref.read(mushafRepositoryProvider.future);
    final pool = await ref.read(wirdPoolProvider.future);
    final repo = ref.read(memorizationRepositoryProvider);
    final portion = today.plan.todayPages;

    final first = mushaf.firstAyahOnPage(portion.first);
    if (first != null) {
      await repo.logWirdShare(
        profileId: profile.id,
        surahNumber: first.surah,
        ayahNumber: first.ayah,
        outcome: outcome,
      );
    }
    final wirdSurahsNow = await ref.read(wirdSurahsProvider.future);
    final byPage = mushaf.firstPageByAyah();
    final pages = portion.toSet();
    final surahRows = await ref.read(surahProgressProvider.future);
    var ayahCount = 0;
    for (final r in surahRows) {
      if (!wirdSurahsNow.contains(r.surahNumber)) continue;
      for (var a = 1; a <= r.totalAyahCount; a++) {
        if (pages.contains(byPage[(surah: r.surahNumber, ayah: a)])) {
          ayahCount++;
        }
      }
    }
    await repo.logStudySession(
      profileId: profile.id,
      kind: 'revision',
      startedAt: _openedAt,
      duration: cappedStudyDuration(DateTime.now().difference(_openedAt)),
      ayahCount: ayahCount,
    );

    // A share to redo stays to be done: the loop does not move on.
    if (outcome != ReciteOutcome.redo) {
      final state = ref.read(wirdControllerProvider);
      final next = advanceWird(
        pool: pool,
        pointer: state.pointer,
        turnsDone: state.turnsDone,
        portion: portion,
      );
      await ref
          .read(wirdControllerProvider.notifier)
          .completeShare(
            pointer: next.pointer,
            turnsDone: next.turnsDone,
            today: DateTime.now(),
          );
    }
    ref.invalidate(wirdTodayProvider);
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
    final todayAsync = ref.watch(wirdTodayProvider);
    final poolEmpty = ref.watch(wirdPoolProvider).value?.isEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wirdTitle)),
      body: SafeArea(
        child: todayAsync.when(
          data: (today) {
            if (today == null) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.wirdIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  if (poolEmpty) ...[
                    Text(
                      l10n.wirdGoalTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const WirdGoalSection(),
                  ],
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Progress(today: today),
                const SizedBox(height: 16),
                if (today.doneToday)
                  _DoneCard(today: today)
                else
                  _Share(
                    today: today,
                    outcome: _outcome,
                    saving: _saving,
                    onOutcome: (o) => setState(() => _outcome = o),
                    onFinish: () => _finish(today),
                  ),
                const SizedBox(height: 24),
                Text(
                  l10n.wirdGoalTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const WirdGoalSection(),
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

  final WirdToday today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plan = today.plan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.wirdIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Text(l10n.wirdTurn(plan.turn), style: theme.textTheme.titleMedium),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: plan.fraction, minHeight: 10),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.wirdProgress(plan.donePagesInTurn, plan.totalPages),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.today});

  final WirdToday today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final next = today.plan.todayPages;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.wirdDoneToday, style: theme.textTheme.bodyLarge),
          if (next.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l10n.wirdNext(next.first), style: theme.textTheme.bodyMedium),
          ],
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

  final WirdToday today;
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
          l10n.wirdTodayCount(pages.length),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final page in pages)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(l10n.wirdPageIn(page, surahOf(page))),
              trailing: const Icon(Icons.menu_book_outlined),
              onTap: () => context.push('/lecture/mushaf?page=$page'),
            ),
          ),
        const SizedBox(height: 16),
        Text(l10n.wirdHow, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        OutcomeTile(
          title: l10n.outcomeClean,
          subtitle: l10n.wirdOutcomeCleanSub,
          selected: outcome == ReciteOutcome.clean,
          onTap: () => onOutcome(ReciteOutcome.clean),
        ),
        OutcomeTile(
          title: l10n.outcomeHesitant,
          subtitle: l10n.wirdOutcomeHesitantSub,
          selected: outcome == ReciteOutcome.hesitant,
          onTap: () => onOutcome(ReciteOutcome.hesitant),
        ),
        OutcomeTile(
          title: l10n.outcomeRedo,
          subtitle: l10n.wirdOutcomeRedoSub,
          selected: outcome == ReciteOutcome.redo,
          onTap: () => onOutcome(ReciteOutcome.redo),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: outcome == null || saving ? null : onFinish,
          child: Text(l10n.wirdFinish),
        ),
      ],
    );
  }
}
