import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/wird/wird_providers.dart';
import '../../../l10n/app_localizations.dart';

/// The Wird's share of the day, as a card that opens it. Nothing at all
/// while no sourate is in the Wird.
class WirdCard extends ConsumerWidget {
  const WirdCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(wirdTodayProvider).value;
    if (today == null) return const SizedBox.shrink();

    final done = today.doneToday;
    return Card(
      child: ListTile(
        leading: Icon(done ? Icons.check_circle_outline : Icons.auto_stories),
        title: Text(l10n.homeWirdTitle),
        subtitle: Text(
          done
              ? l10n.homeWirdDone
              : l10n.homeWirdToday(today.plan.todayPages.length),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/wird'),
      ),
    );
  }
}
