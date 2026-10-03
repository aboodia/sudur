import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/reminders/reminder_scheduler.dart';
import '../../../core/reminders/reminder_settings.dart';
import '../../../l10n/app_localizations.dart';

/// The daily reminder: a switch and the time of day. Turning it on is when
/// the phone's notification permission is asked for — not before.
class ReminderCard extends ConsumerStatefulWidget {
  const ReminderCard({super.key});

  @override
  ConsumerState<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends ConsumerState<ReminderCard> {
  var _permissionDenied = false;

  Future<void> _toggle(bool on) async {
    final controller = ref.read(reminderSettingsProvider.notifier);
    if (!on) {
      setState(() => _permissionDenied = false);
      await controller.setEnabled(false);
      return;
    }
    final granted = await ref
        .read(reminderSchedulerProvider)
        .requestPermission();
    if (!mounted) return;
    setState(() => _permissionDenied = !granted);
    if (granted) await controller.setEnabled(true);
  }

  Future<void> _pickTime() async {
    final settings = ref.read(reminderSettingsProvider);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
    );
    if (picked == null) return;
    await ref
        .read(reminderSettingsProvider.notifier)
        .setTime(picked.hour, picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(reminderSettingsProvider);
    final time =
        '${settings.hour.toString().padLeft(2, '0')}:'
        '${settings.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.reminderSectionTitle, style: theme.textTheme.titleMedium),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.reminderSwitch),
            subtitle: Text(l10n.reminderExplain),
            value: settings.enabled,
            onChanged: settings.loaded ? _toggle : null,
          ),
          if (settings.enabled)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(l10n.reminderTime),
              trailing: Text(time, style: theme.textTheme.titleMedium),
              onTap: _pickTime,
            ),
          if (_permissionDenied)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.reminderPermissionDenied,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
