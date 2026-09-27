import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/database/memorization_repository.dart';
import '../../core/database/review_repository.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/review/review_grouping.dart';

enum _CalendarView { day, week, month }

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// Vue calendaire des révisions (Brique 4, §4.4) : jour / semaine / mois.
/// "Jour" démarre directement la file du jour ([dueUnitsProvider], qui
/// inclut aussi les échéances en retard) ; semaine et mois sont une
/// projection du planning (groupé via [groupByDueDate]) pour visualiser la
/// charge à venir, sans lancer de session.
class ReviewCalendarScreen extends ConsumerStatefulWidget {
  const ReviewCalendarScreen({super.key});

  @override
  ConsumerState<ReviewCalendarScreen> createState() => _ReviewCalendarScreenState();
}

class _ReviewCalendarScreenState extends ConsumerState<ReviewCalendarScreen> {
  _CalendarView _view = _CalendarView.day;
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final allUnitsAsync = ref.watch(memorizationUnitsProvider);
    final dueAsync = ref.watch(dueUnitsProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final reference = referenceAsync.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Révision')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_CalendarView>(
              segments: const [
                ButtonSegment(value: _CalendarView.day, label: Text('Jour')),
                ButtonSegment(value: _CalendarView.week, label: Text('Semaine')),
                ButtonSegment(value: _CalendarView.month, label: Text('Mois')),
              ],
              selected: {_view},
              onSelectionChanged: (selection) => setState(() {
                _view = selection.first;
                _selectedDay = null;
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: allUnitsAsync.when(
                data: (allUnits) {
                  final grouped = groupByDueDate(allUnits);
                  switch (_view) {
                    case _CalendarView.day:
                      return dueAsync.when(
                        data: (due) => _DayView(units: due, reference: reference),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Erreur : $err')),
                      );
                    case _CalendarView.week:
                      return _WeekView(
                        grouped: grouped,
                        selectedDay: _selectedDay,
                        onSelectDay: (day) => setState(() => _selectedDay = day),
                        reference: reference,
                      );
                    case _CalendarView.month:
                      return _MonthView(
                        grouped: grouped,
                        selectedDay: _selectedDay,
                        onSelectDay: (day) => setState(() => _selectedDay = day),
                        reference: reference,
                      );
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Erreur : $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayView extends StatelessWidget {
  const _DayView({required this.units, required this.reference});

  final List<MemorizationUnit> units;
  final QuranReferenceRepository? reference;

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return const Center(child: Text("Rien à réviser aujourd'hui."));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: units.length,
            itemBuilder: (context, i) => _UnitTile(unit: units[i], reference: reference),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => context.push('/revision/session'),
          icon: const Icon(Icons.refresh),
          label: Text(units.length == 1 ? 'Démarrer la révision (1)' : 'Démarrer la révision (${units.length})'),
        ),
      ],
    );
  }
}

class _WeekView extends StatelessWidget {
  const _WeekView({
    required this.grouped,
    required this.selectedDay,
    required this.onSelectDay,
    required this.reference,
  });

  final Map<DateTime, List<MemorizationUnit>> grouped;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onSelectDay;
  final QuranReferenceRepository? reference;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final days = [for (var i = 0; i < 7; i++) startOfToday.add(Duration(days: i))];
    final selected = selectedDay ?? startOfToday;
    final unitsForSelected = grouped[selected] ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 76,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final day in days)
                _DayChip(
                  day: day,
                  count: grouped[day]?.length ?? 0,
                  selected: _isSameDay(day, selected),
                  onTap: () => onSelectDay(day),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: unitsForSelected.isEmpty
              ? const Center(child: Text('Rien de prévu ce jour-là.'))
              : ListView.builder(
                  itemCount: unitsForSelected.length,
                  itemBuilder: (context, i) => _UnitTile(unit: unitsForSelected[i], reference: reference),
                ),
        ),
      ],
    );
  }
}

class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.grouped,
    required this.selectedDay,
    required this.onSelectDay,
    required this.reference,
  });

  final Map<DateTime, List<MemorizationUnit>> grouped;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onSelectDay;
  final QuranReferenceRepository? reference;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday - 1; // Monday = 1 → 0 blancs
    final selected = selectedDay ?? DateTime(now.year, now.month, now.day);
    final unitsForSelected = grouped[selected] ?? const [];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: leadingBlanks + daysInMonth,
          itemBuilder: (context, index) {
            if (index < leadingBlanks) return const SizedBox.shrink();
            final day = DateTime(now.year, now.month, index - leadingBlanks + 1);
            final count = grouped[day]?.length ?? 0;
            final isSelected = _isSameDay(day, selected);
            return GestureDetector(
              onTap: () => onSelectDay(day),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primaryContainer : null,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${day.day}', style: theme.textTheme.bodySmall),
                    if (count > 0)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: unitsForSelected.isEmpty
              ? const Center(child: Text('Rien de prévu ce jour-là.'))
              : ListView.builder(
                  itemCount: unitsForSelected.length,
                  itemBuilder: (context, i) => _UnitTile(unit: unitsForSelected[i], reference: reference),
                ),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.day, required this.count, required this.selected, required this.onTap});

  final DateTime day;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  static const _weekdayLabels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_weekdayLabels[day.weekday - 1], style: theme.textTheme.labelSmall),
              Text('${day.day}', style: theme.textTheme.titleMedium),
              if (count > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                  child: Text('$count', style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 11)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  const _UnitTile({required this.unit, required this.reference});

  final MemorizationUnit unit;
  final QuranReferenceRepository? reference;

  IconData get _masteryIcon => switch (unit.masteryLevel) {
        'weak' => Icons.trending_down,
        'medium' => Icons.trending_flat,
        'solid' => Icons.trending_up,
        _ => Icons.help_outline,
      };

  String get _circleLabel => switch (unit.circle) {
        1 => 'Cercle quotidien',
        2 => 'Cercle hebdomadaire',
        3 => 'Cercle mensuel',
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    final name = reference?.surahByNumber(unit.surahNumber).englishName ?? 'Sourate ${unit.surahNumber}';
    final label =
        unit.startAyah == unit.endAyah ? 'verset ${unit.startAyah}' : 'versets ${unit.startAyah}-${unit.endAyah}';
    return ListTile(
      leading: Icon(_masteryIcon),
      title: Text('$name — $label'),
      subtitle: _circleLabel.isEmpty ? null : Text(_circleLabel),
    );
  }
}
