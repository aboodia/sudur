import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/format/french_date.dart';
import '../../../core/memorization/review_calendar.dart';
import '../../../core/stats/progress_history.dart';
import '../../../core/stats/progress_history_provider.dart';
import '../../../l10n/app_localizations.dart';
import 'goals_section.dart';
import 'mushaf_map.dart';
import 'progress_curve.dart';

/// "Suivi": the progress curve, the Mushaf map and the session history —
/// the detailed side of Le Chemin.
class FollowUpView extends ConsumerStatefulWidget {
  const FollowUpView({super.key});

  @override
  ConsumerState<FollowUpView> createState() => _FollowUpViewState();
}

class _FollowUpViewState extends ConsumerState<FollowUpView>
    with AutomaticKeepAliveClientMixin {
  var _period = HistoryPeriod.days30;

  // Switching to the Trace tab and back keeps the chosen period and the
  // scroll position.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const GoalsSection(),
        const SizedBox(height: 32),
        Text(l10n.curveTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        SegmentedButton<HistoryPeriod>(
          segments: [
            ButtonSegment(
              value: HistoryPeriod.days30,
              label: Text(l10n.curvePeriod30),
            ),
            ButtonSegment(
              value: HistoryPeriod.days90,
              label: Text(l10n.curvePeriod90),
            ),
            ButtonSegment(
              value: HistoryPeriod.all,
              label: Text(l10n.curvePeriodAll),
            ),
          ],
          selected: {_period},
          onSelectionChanged: (s) => setState(() => _period = s.first),
        ),
        const SizedBox(height: 16),
        _CurveSection(period: _period),
        const SizedBox(height: 32),
        Text(l10n.mapTitle, style: theme.textTheme.titleLarge),
        Text(l10n.mapSubtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        const _MapSection(),
        const SizedBox(height: 32),
        Text(l10n.historyTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        const _HistorySection(),
      ],
    );
  }
}

class _CurveSection extends ConsumerWidget {
  const _CurveSection({required this.period});

  final HistoryPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final eventsAsync = ref.watch(memorizationEventsProvider);

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(l10n.curveEmpty, style: theme.textTheme.bodyMedium),
          );
        }
        final today = dateOnly(DateTime.now());
        final start = historyStart(period, events, today);
        // The curve starts from what was known before joining; only the
        // verses learned since are progress.
        final baseline = ref.watch(declaredBaselineProvider).value ?? 0;
        final series = [
          for (final v in cumulativeSeries(events, from: start, to: today))
            v + baseline,
        ];
        final gain = versesGained(events, from: start, to: today);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressCurve(series: series, start: start, end: today),
            const SizedBox(height: 8),
            Text(
              gain > 0 ? l10n.curveGain(gain) : l10n.curveNoGain,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Text('Erreur : $err'),
    );
  }
}

class _MapSection extends ConsumerWidget {
  const _MapSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverageAsync = ref.watch(mushafCoverageProvider);
    return coverageAsync.when(
      data: (coverage) => MushafMap(
        coverage: coverage,
        onPageTap: (page) => context.push('/lecture/mushaf?page=$page'),
      ),
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Text('Erreur : $err'),
    );
  }
}

class _HistorySection extends ConsumerWidget {
  const _HistorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final historyAsync = ref.watch(studyHistoryProvider);

    return historyAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.historyEmpty, style: theme.textTheme.bodyMedium),
          );
        }
        return Column(
          children: [for (final s in sessions) _HistoryRow(session: s)],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, _) => Text('Erreur : $err'),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.session});

  final StudySessionEntry session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRevision = session.kind == 'revision';
    final started = session.startedAt;
    final time =
        '${started.hour.toString().padLeft(2, '0')}:'
        '${started.minute.toString().padLeft(2, '0')}';
    final when =
        '${capitalizeFirst(frenchRelativeDay(started, DateTime.now()))} $time';
    // Under a minute still reads as a minute: "0 min" for a real session
    // looks like a mistake.
    final minutes = (session.durationSeconds / 60).ceil().clamp(1, 600);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isRevision ? Icons.refresh : Icons.menu_book_outlined,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.historyLine(
                    isRevision
                        ? l10n.historyKindRevision
                        : l10n.historyKindMemorization,
                    session.ayahCount,
                  ),
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  l10n.historyDetail(when, minutes),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
