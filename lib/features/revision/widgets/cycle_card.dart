import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/revision/review_cycle_provider.dart';
import '../../../l10n/app_localizations.dart';

/// The revision cycle's share of the day, as a card that opens it. Nothing
/// at all when the user declared no sourate as already memorized.
class CycleCard extends ConsumerWidget {
  const CycleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(cycleTodayProvider).value;
    if (today == null) return const SizedBox.shrink();

    final done = today.doneToday;
    return Card(
      child: ListTile(
        leading: Icon(done ? Icons.check_circle_outline : Icons.auto_stories),
        title: Text(l10n.homeCycleTitle),
        subtitle: Text(
          done
              ? l10n.homeCycleDone
              : l10n.homeCycleToday(today.plan.todayPages.length),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/revision/cycle'),
      ),
    );
  }
}
