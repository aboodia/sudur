import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/path/milestones.dart';
import '../../core/path/path_providers.dart';
import '../../core/quran_reference/quran_reference_models.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/follow_up_view.dart';
import 'widgets/milestone_sheet.dart';

/// Le Chemin (Siraat): the 114 sourates as milestones along one path —
/// completed, current, still ahead — opening on where the user is now,
/// next to the detailed follow-up (curve, Mushaf map, history).
class PathScreen extends ConsumerWidget {
  const PathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final milestonesAsync = ref.watch(milestonesProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.pathTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.pathTabTrace),
              Tab(text: l10n.pathTabFollowUp),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: milestonesAsync.when(
                data: (milestones) => referenceAsync.when(
                  data: (reference) => _PathContent(
                    milestones: milestones,
                    reference: reference,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Erreur : $err')),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Erreur : $err')),
              ),
            ),
            const SafeArea(child: FollowUpView()),
          ],
        ),
      ),
    );
  }
}

class _PathContent extends StatefulWidget {
  const _PathContent({required this.milestones, required this.reference});

  final List<Milestone> milestones;
  final QuranReferenceRepository reference;

  @override
  State<_PathContent> createState() => _PathContentState();
}

class _PathContentState extends State<_PathContent>
    with AutomaticKeepAliveClientMixin {
  // Switching to the follow-up tab and back must not jump the path back to
  // the current milestone.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final milestones = widget.milestones;
    final reference = widget.reference;
    final current = currentMilestone(milestones);
    // Open one step before the current milestone, so the way just walked
    // stays in view above it.
    final startIndex = current == null
        ? 0
        : (current.surahNumber - 2).clamp(0, 113);

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          // With the text enlarged the card can be taller than the screen can
          // spare: it then scrolls on its own, and the path keeps its room.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.45,
            ),
            child: SingleChildScrollView(
              child: _SummaryCard(
                milestones: milestones,
                reference: reference,
                current: current,
              ),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              initialScrollIndex: startIndex,
              itemCount: milestones.length,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemBuilder: (context, index) {
                final m = milestones[index];
                return _MilestoneTile(
                  milestone: m,
                  surah: reference.surahByNumber(m.surahNumber),
                  isFirst: index == 0,
                  isLast: index == milestones.length - 1,
                  previousCompleted:
                      index > 0 &&
                      milestones[index - 1].state == MilestoneState.completed,
                  onTap: () => showMilestoneSheet(context, m),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.milestones,
    required this.reference,
    required this.current,
  });

  final List<Milestone> milestones;
  final QuranReferenceRepository reference;
  final Milestone? current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final done = completedMilestones(milestones);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pathSummaryTitle(done, milestones.length),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: done / milestones.length,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          if (current == null)
            Text(l10n.pathAllDone, style: theme.textTheme.bodyMedium)
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.pathNextStep(
                      reference.surahByNumber(current!.surahNumber).englishName,
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                FilledButton(
                  onPressed: () => context.push('/memoriser'),
                  child: Text(l10n.pathContinue),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The sourate's name in French and in Arabic: side by side, or one above
/// the other when the text is enlarged enough that they would not both fit.
class _SurahNames extends StatelessWidget {
  const _SurahNames({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final english = Text(surah.englishName, style: theme.textTheme.titleMedium);
    final arabic = Text(
      surah.nameArabic,
      textDirection: TextDirection.rtl,
      style: const TextStyle(
        fontFamily: 'AmiriQuran',
        fontSize: 22,
        // The script's marks reach below the line: without the height
        // they overlap the subtitle.
        height: 1.7,
      ),
    );
    final enlarged = MediaQuery.textScalerOf(context).scale(14) > 14 * 1.4;
    if (enlarged) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          english,
          Align(alignment: AlignmentDirectional.centerEnd, child: arabic),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: english),
        arabic,
      ],
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({
    required this.milestone,
    required this.surah,
    required this.isFirst,
    required this.isLast,
    required this.previousCompleted,
    required this.onTap,
  });

  final Milestone milestone;
  final Surah surah;
  final bool isFirst;
  final bool isLast;
  final bool previousCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = milestone.state;

    final stateLabel = switch (state) {
      MilestoneState.completed => l10n.milestoneCompleted,
      MilestoneState.current => l10n.milestoneCurrent,
      MilestoneState.locked => l10n.milestoneLocked,
    };
    final lineAbove = previousCompleted
        ? scheme.primary
        : scheme.outlineVariant;
    final lineBelow = state == MilestoneState.completed
        ? scheme.primary
        : scheme.outlineVariant;

    return Semantics(
      button: true,
      label: l10n.milestoneSemantics(
        milestone.surahNumber,
        surah.englishName,
        stateLabel,
      ),
      child: ExcludeSemantics(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 56,
                child: Column(
                  children: [
                    Expanded(
                      child: _Line(
                        color: isFirst ? Colors.transparent : lineAbove,
                      ),
                    ),
                    _Node(milestone: milestone),
                    Expanded(
                      child: _Line(
                        color: isLast ? Colors.transparent : lineBelow,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: state == MilestoneState.current
                            ? scheme.tertiaryContainer.withValues(alpha: 0.35)
                            : null,
                        border: Border.all(
                          color: state == MilestoneState.current
                              ? scheme.tertiary
                              : scheme.outlineVariant,
                          width: state == MilestoneState.current ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Opacity(
                        opacity: state == MilestoneState.locked ? 0.65 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SurahNames(surah: surah),
                            const SizedBox(height: 8),
                            Text(
                              '$stateLabel · ${l10n.milestoneVersesAndType(surah.numberOfAyahs, revelationLabel(l10n, surah))}',
                              style: theme.textTheme.bodySmall,
                            ),
                            if (state == MilestoneState.current) ...[
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: milestone.progress,
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.surahProgressCount(
                                  milestone.memorizedAyahs,
                                  milestone.totalAyahs,
                                ),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Center(child: Container(width: 3, color: color));
}

class _Node extends StatelessWidget {
  const _Node({required this.milestone});

  final Milestone milestone;

  static const _size = 40.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (milestone.state) {
      case MilestoneState.completed:
        return Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: scheme.onPrimary),
        );
      case MilestoneState.current:
        return Container(
          width: _size,
          height: _size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: scheme.tertiary, width: 3),
          ),
          child: Text(
            '${milestone.surahNumber}',
            style: TextStyle(
              color: scheme.tertiary,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.liningFigures()],
            ),
          ),
        );
      case MilestoneState.locked:
        return Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.lock_outline, size: 18, color: scheme.outline),
        );
    }
  }
}
