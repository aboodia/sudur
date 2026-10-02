import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../../../core/format/french_date.dart';
import '../../../core/memorization/mastery.dart';
import '../../../core/memorization/review_calendar.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../l10n/app_localizations.dart';
import 'mastery_widgets.dart';

enum RevisionCalendarView { day, week, month }

MasteryLevel _levelOf(AyahProgressEntry e) =>
    masteryFor(lastOutcome: e.lastOutcome, cycleStep: e.reviewCycleStep);

/// What's coming up for review, by day / week / month. Everything already
/// overdue is shown on today — a missed day is never lost.
class RevisionCalendar extends StatefulWidget {
  const RevisionCalendar({
    super.key,
    required this.entries,
    required this.reference,
    required this.today,
  });

  final List<AyahProgressEntry> entries;
  final QuranReferenceRepository reference;

  /// Midnight of the current day (injected so tests don't depend on the clock).
  final DateTime today;

  @override
  State<RevisionCalendar> createState() => _RevisionCalendarState();
}

class _RevisionCalendarState extends State<RevisionCalendar> {
  static const _monthsAhead = 12;

  var _view = RevisionCalendarView.day;
  late DateTime _visibleMonth = DateTime(widget.today.year, widget.today.month);
  late DateTime _selectedDay = widget.today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final byDay = groupByDueDay<AyahProgressEntry>(
      widget.entries,
      (e) => e.nextReviewAt,
      today: widget.today,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<RevisionCalendarView>(
          segments: [
            ButtonSegment(
              value: RevisionCalendarView.day,
              label: Text(l10n.revisionViewDay),
            ),
            ButtonSegment(
              value: RevisionCalendarView.week,
              label: Text(l10n.revisionViewWeek),
            ),
            ButtonSegment(
              value: RevisionCalendarView.month,
              label: Text(l10n.revisionViewMonth),
            ),
          ],
          selected: {_view},
          onSelectionChanged: (s) => setState(() => _view = s.first),
        ),
        const SizedBox(height: 12),
        switch (_view) {
          RevisionCalendarView.day => PassageList(
            entries: byDay[widget.today] ?? const [],
            reference: widget.reference,
          ),
          RevisionCalendarView.week => _buildWeek(context, byDay),
          RevisionCalendarView.month => _buildMonth(context, byDay),
        },
      ],
    );
  }

  Widget _buildWeek(
    BuildContext context,
    Map<DateTime, List<AyahProgressEntry>> byDay,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        for (var i = 0; i < 7; i++)
          Builder(
            builder: (context) {
              // Not `today.add(Duration(days: i))`: that drifts by an hour
              // across a clock change and can land on the wrong date.
              final day = DateTime(
                widget.today.year,
                widget.today.month,
                widget.today.day + i,
              );
              final entries = byDay[day] ?? const [];
              final passages = groupIntoPassages([
                for (final e in entries)
                  (surah: e.surahNumber, ayah: e.ayahNumber),
              ]);
              final isToday = i == 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isToday
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.35,
                        )
                      : null,
                  border: Border.all(
                    color: isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 108,
                      child: Text(
                        capitalizeFirst(frenchRelativeDay(day, widget.today)),
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Expanded(
                      child: entries.isEmpty
                          ? Text('—', style: theme.textTheme.bodyMedium)
                          : Text(
                              passages
                                  .map((p) => _passageLabel(l10n, p))
                                  .join(' · '),
                              style: theme.textTheme.bodyMedium,
                            ),
                    ),
                    if (entries.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        l10n.statVerses(entries.length),
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  String _passageLabel(AppLocalizations l10n, PassageRange p) {
    final name = widget.reference.surahByNumber(p.surahNumber).englishName;
    return p.length == 1
        ? l10n.revisionPassageSingle(name, p.ayahStart)
        : l10n.revisionPassageRange(name, p.ayahStart, p.ayahEnd);
  }

  Widget _buildMonth(
    BuildContext context,
    Map<DateTime, List<AyahProgressEntry>> byDay,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentMonth = DateTime(widget.today.year, widget.today.month);
    final lastMonth = DateTime(
      currentMonth.year,
      currentMonth.month + _monthsAhead,
    );
    final canGoBack = _visibleMonth.isAfter(currentMonth);
    final canGoForward = _visibleMonth.isBefore(lastMonth);
    final weeks = monthGrid(_visibleMonth.year, _visibleMonth.month);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: l10n.revisionPreviousMonth,
              onPressed: canGoBack
                  ? () => setState(
                      () => _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month - 1,
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                '${capitalizeFirst(frenchMonth(_visibleMonth.month))} '
                '${_visibleMonth.year}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: l10n.revisionNextMonth,
              onPressed: canGoForward
                  ? () => setState(
                      () => _visibleMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month + 1,
                      ),
                    )
                  : null,
            ),
          ],
        ),
        Row(
          children: [
            for (var wd = 1; wd <= 7; wd++)
              Expanded(
                child: Center(
                  child: Text(
                    frenchWeekdayInitial(wd),
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (final week in weeks)
          Row(
            children: [
              for (final day in week)
                Expanded(
                  child: day == null
                      ? const SizedBox(height: 52)
                      : _DayCell(
                          day: day,
                          count: (byDay[day] ?? const []).length,
                          isToday: day == widget.today,
                          isSelected: day == _selectedDay,
                          onTap: () => setState(() => _selectedDay = day),
                        ),
                ),
            ],
          ),
        const SizedBox(height: 12),
        PassageList(
          entries: byDay[_selectedDay] ?? const [],
          reference: widget.reference,
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.count,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime day;
  final int count;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${frenchDateLabel(day)}${count > 0 ? ', $count' : ''}',
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 52,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                : null,
            border: isToday
                ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${day.day}', style: theme.textTheme.bodyMedium),
              if (count > 0)
                Text(
                  '$count',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

/// The verses due on one day, merged into passages ("Al-Mulk · versets 1 à
/// 5"), each with how well it is mastered.
class PassageList extends StatelessWidget {
  const PassageList({
    super.key,
    required this.entries,
    required this.reference,
  });

  final List<AyahProgressEntry> entries;
  final QuranReferenceRepository reference;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          l10n.revisionNothingThatDay,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final passages = groupIntoPassages([
      for (final e in entries) (surah: e.surahNumber, ayah: e.ayahNumber),
    ]);

    return Column(
      children: [
        for (final p in passages)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    p.length == 1
                        ? l10n.revisionPassageSingle(
                            reference.surahByNumber(p.surahNumber).englishName,
                            p.ayahStart,
                          )
                        : l10n.revisionPassageRange(
                            reference.surahByNumber(p.surahNumber).englishName,
                            p.ayahStart,
                            p.ayahEnd,
                          ),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 64,
                  child: MasteryBar(
                    counts: MasteryCounts.of(
                      entries
                          .where(
                            (e) =>
                                e.surahNumber == p.surahNumber &&
                                e.ayahNumber >= p.ayahStart &&
                                e.ayahNumber <= p.ayahEnd,
                          )
                          .map(_levelOf),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
