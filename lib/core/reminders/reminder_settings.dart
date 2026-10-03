import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The daily reminder: off until the user turns it on, at a time they pick.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = 20,
    this.minute = 0,
    this.loaded = false,
  });

  final bool enabled;
  final int hour;
  final int minute;

  /// Whether the saved values have been read yet — until then the defaults
  /// above must not be mistaken for the user's choice.
  final bool loaded;

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        loaded: true,
      );
}

const _kEnabledKey = 'reminder.enabled';
const _kHourKey = 'reminder.hour';
const _kMinuteKey = 'reminder.minute';

class ReminderSettingsController extends Notifier<ReminderSettings> {
  @override
  ReminderSettings build() {
    _restore();
    return const ReminderSettings();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!ref.mounted) return;
    state = ReminderSettings(
      enabled: prefs.getBool(_kEnabledKey) ?? false,
      hour: (prefs.getInt(_kHourKey) ?? 20).clamp(0, 23),
      minute: (prefs.getInt(_kMinuteKey) ?? 0).clamp(0, 59),
      loaded: true,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEnabledKey, enabled);
  }

  Future<void> setTime(int hour, int minute) async {
    state = state.copyWith(hour: hour, minute: minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kHourKey, hour);
    await prefs.setInt(_kMinuteKey, minute);
  }
}

final reminderSettingsProvider =
    NotifierProvider<ReminderSettingsController, ReminderSettings>(
      ReminderSettingsController.new,
    );
