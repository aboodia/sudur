import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/memorization_repository.dart';
import '../../../core/format/french_date.dart';
import '../../../core/memorization/mastery.dart';
import '../../../core/memorization/review_calendar.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/mastery_widgets.dart';
import '../widgets/revision_calendar.dart';

MasteryLevel _levelOf(AyahProgressEntry e) =>
    masteryFor(lastOutcome: e.lastOutcome, cycleStep: e.reviewCycleStep);

/// "Révision" — today's session, what's coming up (day / week / month) and
/// how well each sourate is mastered. Opened from the Accueil card; the
/// session itself is `/revision/session`.
class RevisionHubScreen extends ConsumerWidget {
  const RevisionHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(ayahProgressProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.revisionHubTitle)),
      body: SafeArea(
        child: progressAsync.when(
          data: (entries) => referenceAsync.when(
            data: (reference) =>
                _Content(entries: entries, reference: reference),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Erreur : $err')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erreur : $err')),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.entries, required this.reference});

  final List<AyahProgressEntry> entries;
  final QuranReferenceRepository reference;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final today = dateOnly(DateTime.now());

    if (entries.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.revisionNothingYet,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      );
    }

    final byDay = groupByDueDay<AyahProgressEntry>(
      entries,
      (e) => e.nextReviewAt,
      today: today,
    );
    final dueToday = byDay[today] ?? const <AyahProgressEntry>[];
    final upcomingDays = byDay.keys.where((d) => d.isAfter(today)).toList()
      ..sort();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (dueToday.isEmpty)
          _UpToDateCard(
            nextDay: upcomingDays.isEmpty ? null : upcomingDays.first,
            today: today,
          )
        else
          _TodayCard(dueToday: dueToday, reference: reference),
        const SizedBox(height: 24),
        Text(l10n.revisionCalendarTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        RevisionCalendar(entries: entries, reference: reference, today: today),
        const SizedBox(height: 24),
        Text(l10n.revisionMasteryTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(l10n.revisionMasteryHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        _MasterySection(entries: entries, reference: reference),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.dueToday, required this.reference});

  final List<AyahProgressEntry> dueToday;
  final QuranReferenceRepository reference;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final passages = groupIntoPassages([
      for (final e in dueToday) (surah: e.surahNumber, ayah: e.ayahNumber),
    ]);
    // A few passages, then "+ N" — the full list is in the calendar below.
    final shown = passages
        .take(3)
        .map((p) {
          final name = reference.surahByNumber(p.surahNumber).englishName;
          return p.length == 1
              ? l10n.revisionPassageSingle(name, p.ayahStart)
              : l10n.revisionPassageRange(name, p.ayahStart, p.ayahEnd);
        })
        .join('\n');
    final more = passages.length - 3;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.revisionTodayLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.tertiaryContainer,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                l10n.estimatedDuration(dueToday.length.clamp(2, 30)),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.statVerses(dueToday.length),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: scheme.onPrimary,
              fontFeatures: const [FontFeature.liningFigures()],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            more > 0 ? '$shown\n+ $more' : shown,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.onPrimary,
                foregroundColor: scheme.primary,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => context.push('/revision/session'),
              child: Text(l10n.revisionStart),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpToDateCard extends StatelessWidget {
  const _UpToDateCard({required this.nextDay, required this.today});

  final DateTime? nextDay;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.revisionUpToDateTitle,
                    style: theme.textTheme.titleLarge,
                  ),
                  Text(
                    l10n.revisionUpToDateSubtitle,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (nextDay != null)
                    Text(
                      l10n.revisionNextDue(frenchRelativeDay(nextDay!, today)),
                      style: theme.textTheme.bodyMedium,
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

class _MasterySection extends StatelessWidget {
  const _MasterySection({required this.entries, required this.reference});

  final List<AyahProgressEntry> entries;
  final QuranReferenceRepository reference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bySurah = <int, List<AyahProgressEntry>>{};
    for (final e in entries) {
      bySurah.putIfAbsent(e.surahNumber, () => []).add(e);
    }
    final surahNumbers = bySurah.keys.toList()..sort();
    final overall = MasteryCounts.of(entries.map(_levelOf));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MasteryBar(counts: overall, height: 12),
        const SizedBox(height: 8),
        MasteryLegend(counts: overall),
        const SizedBox(height: 16),
        for (final n in surahNumbers)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reference.surahByNumber(n).englishName,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                MasteryBar(counts: MasteryCounts.of(bySurah[n]!.map(_levelOf))),
                const SizedBox(height: 4),
                MasteryLegend(
                  counts: MasteryCounts.of(bySurah[n]!.map(_levelOf)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
