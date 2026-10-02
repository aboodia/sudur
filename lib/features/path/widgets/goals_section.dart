import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/profile_repository.dart';
import '../../../core/stats/goals.dart';
import '../../../core/stats/goals_provider.dart';
import '../../../l10n/app_localizations.dart';

/// Weekly and monthly goals: how many new verses, how many are done, and
/// what is left — said as encouragement, never as a reproach.
class GoalsSection extends ConsumerWidget {
  const GoalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final goalsAsync = ref.watch(goalsProvider);

    return goalsAsync.when(
      data: (goals) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.goalsTitle, style: theme.textTheme.titleLarge),
              ),
              TextButton.icon(
                onPressed: () => showGoalsEditor(context, goals),
                icon: const Icon(Icons.tune, size: 18),
                label: Text(l10n.goalsEdit),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _GoalCard(title: l10n.goalWeekTitle, progress: goals.week),
          const SizedBox(height: 12),
          _GoalCard(title: l10n.goalMonthTitle, progress: goals.month),
          if (goals.weeklyIsDefault || goals.monthlyIsDefault) ...[
            const SizedBox(height: 8),
            Text(l10n.goalSuggested, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Text('Erreur : $err'),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.title, required this.progress});

  final String title;
  final GoalProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = progress;

    final String message;
    if (p.reached) {
      message = l10n.goalReached;
    } else if (p.aheadOfPace) {
      message =
          '${l10n.goalAhead} '
          '${l10n.goalRemaining(p.remaining, p.perDayNeeded)}';
    } else {
      message = l10n.goalRemaining(p.remaining, p.perDayNeeded);
    }

    return Semantics(
      label: l10n.goalSemantics(title, p.done, p.goal),
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleMedium),
                  ),
                  Text(
                    l10n.goalCount(p.done, p.goal),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: p.fraction,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (p.reached) ...[
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(message, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showGoalsEditor(BuildContext context, GoalsState goals) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _GoalsEditor(goals: goals),
  );
}

class _GoalsEditor extends ConsumerStatefulWidget {
  const _GoalsEditor({required this.goals});

  final GoalsState goals;

  @override
  ConsumerState<_GoalsEditor> createState() => _GoalsEditorState();
}

class _GoalsEditorState extends ConsumerState<_GoalsEditor> {
  late int _weekly = widget.goals.week.goal;
  late int _monthly = widget.goals.month.goal;

  Future<void> _save({required bool reset}) async {
    final profile = await ref.read(currentProfileProvider.future);
    final defaults = widget.goals.defaults;
    // A value equal to the proposal is stored as "not chosen", so it keeps
    // following the daily time if that changes.
    final weekly = reset || _weekly == defaults.weekly ? null : _weekly;
    final monthly = reset || _monthly == defaults.monthly ? null : _monthly;
    await ref
        .read(userProfileRepositoryProvider)
        .setGoals(id: profile.id, weekly: weekly, monthly: monthly);
    ref.invalidate(currentProfileProvider);
    ref.invalidate(goalsProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final defaults = widget.goals.defaults;
    final isDefault =
        _weekly == defaults.weekly && _monthly == defaults.monthly;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.goalEditTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(l10n.goalEditHint, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            _Stepper(
              label: l10n.goalEditWeekly,
              value: _weekly,
              max: maxWeeklyGoal,
              onChanged: (v) => setState(() => _weekly = v),
            ),
            const SizedBox(height: 12),
            _Stepper(
              label: l10n.goalEditMonthly,
              value: _monthly,
              max: maxMonthlyGoal,
              onChanged: (v) => setState(() => _monthly = v),
            ),
            const SizedBox(height: 16),
            if (!isDefault)
              TextButton(
                onPressed: () => setState(() {
                  _weekly = defaults.weekly;
                  _monthly = defaults.monthly;
                }),
                child: Text(l10n.goalEditReset),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _save(reset: false),
                child: Text(l10n.goalEditSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
        IconButton.outlined(
          tooltip: l10n.goalEditDecrease,
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 56,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            // The serif's old-style figures make "21" read as "2I".
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 22),
          ),
        ),
        IconButton.outlined(
          tooltip: l10n.goalEditIncrease,
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
