import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/wird/wird_plan.dart';
import '../../../core/wird/wird_providers.dart';
import '../../../core/wird/wird_state.dart';
import '../../../l10n/app_localizations.dart';

/// Picks the daily Wird goal: a number of pages or of Juz a day. Holds no
/// state of its own — the caller decides where the choice is kept.
class WirdGoalEditor extends StatelessWidget {
  const WirdGoalEditor({
    super.key,
    required this.unit,
    required this.amount,
    required this.onChanged,
  });

  final WirdUnit unit;
  final int amount;
  final void Function(WirdUnit unit, int amount) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final max = maxWirdAmount(unit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<WirdUnit>(
          segments: [
            ButtonSegment(
              value: WirdUnit.pages,
              label: Text(l10n.wirdUnitPages),
            ),
            ButtonSegment(value: WirdUnit.juz, label: Text(l10n.wirdUnitJuz)),
          ],
          selected: {unit},
          showSelectedIcon: false,
          onSelectionChanged: (s) {
            final next = s.first;
            // Keep a similar quantity when switching: a Juz is 20 pages.
            final pages = wirdGoalPages(unit, amount);
            final converted = next == WirdUnit.juz
                ? (pages / pagesPerJuz).round()
                : pages;
            onChanged(next, converted.clamp(1, maxWirdAmount(next)));
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              tooltip: l10n.wirdLess,
              onPressed: amount > 1 ? () => onChanged(unit, amount - 1) : null,
              icon: const Icon(Icons.remove),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  unit == WirdUnit.pages
                      ? l10n.wirdGoalPagesValue(amount)
                      : l10n.wirdGoalJuzValue(amount),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            IconButton.filledTonal(
              tooltip: l10n.wirdMore,
              onPressed: amount < max
                  ? () => onChanged(unit, amount + 1)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}

/// The goal editor bound to the saved Wird settings, for the Wird screen and
/// the Profil.
class WirdGoalSection extends ConsumerWidget {
  const WirdGoalSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(wirdControllerProvider);
    final today = ref.watch(wirdTodayProvider).value;
    final pool = ref.watch(wirdPoolProvider).value ?? const <int>[];

    // Before the user has chosen, show the suggestion (or a plain 1 page
    // while no sourate is in the Wird yet).
    final unit = today?.unit ?? state.unit;
    final amount =
        today?.amount ??
        state.amount ??
        (pool.isEmpty ? 1 : suggestedWirdPages(pool.length));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WirdGoalEditor(
          unit: unit,
          amount: amount,
          onChanged: (u, a) =>
              ref.read(wirdControllerProvider.notifier).setGoal(u, a),
        ),
        const SizedBox(height: 8),
        if (today != null && today.isSuggested)
          Text(
            l10n.wirdGoalSuggested,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (pool.isEmpty)
          Text(
            l10n.wirdGoalNoSourates,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          )
        else
          Text(
            l10n.wirdLoopIn(
              daysToLoop(pool.length, wirdGoalPages(unit, amount)),
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}
