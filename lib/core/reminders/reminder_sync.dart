import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../database/memorization_repository.dart';
import '../database/profile_repository.dart';
import '../stats/progress_stats_provider.dart';
import 'reminder_plan.dart';
import 'reminder_scheduler.dart';
import 'reminder_settings.dart';

/// First id used for the reminders; they take [reminderCount] ids from here.
const reminderFirstId = 100;

/// Keeps the scheduled notifications in line with the settings and with
/// what the user has done: recomputed when they change the reminder, when
/// they study (the stats are refreshed then) and when the app comes back to
/// the foreground.
final reminderSyncProvider = FutureProvider<void>((ref) async {
  final settings = ref.watch(reminderSettingsProvider);
  if (!settings.loaded) return;

  final scheduler = ref.watch(reminderSchedulerProvider);
  if (!settings.enabled) {
    await scheduler.cancelAll();
    return;
  }
  // Switched on but the permission was refused or later withdrawn.
  if (!await scheduler.hasPermission()) {
    await scheduler.cancelAll();
    return;
  }

  final profile = await ref.watch(currentProfileProvider.future);
  // Studying refreshes the stats: that is what reruns this.
  await ref.watch(progressStatsProvider.future);
  final log = await ref
      .watch(memorizationRepositoryProvider)
      .reviewLog(profile.id);
  DateTime? last;
  for (final entry in log) {
    if (last == null || entry.occurredAt.isAfter(last)) last = entry.occurredAt;
  }

  final planned = planReminders(
    now: DateTime.now(),
    hour: settings.hour,
    minute: settings.minute,
    availableDaysMask: profile.availableDaysMask,
    lastActivity: last,
  );

  final l10n = lookupAppLocalizations(const Locale('fr'));
  await scheduler.replaceAll([
    for (var i = 0; i < planned.length; i++)
      ScheduledReminder(
        id: reminderFirstId + i,
        at: planned[i].at,
        title: l10n.reminderTitle,
        body: planned[i].kind == ReminderKind.comeBack
            ? l10n.reminderBodyComeBack
            : l10n.reminderBody,
      ),
  ]);
});

/// Keeps [reminderSyncProvider] alive for the whole app and reruns it when
/// the app returns to the foreground (the clock may have moved on, or the
/// permission changed in the phone's settings).
class ReminderSyncHost extends ConsumerStatefulWidget {
  const ReminderSyncHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderSyncHost> createState() => _ReminderSyncHostState();
}

class _ReminderSyncHostState extends ConsumerState<ReminderSyncHost>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(reminderSyncProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(reminderSyncProvider);
    return widget.child;
  }
}
