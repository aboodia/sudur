import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// A notification to show at [at].
class ScheduledReminder {
  const ScheduledReminder({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
  });

  final int id;
  final DateTime at;
  final String title;
  final String body;
}

/// What the app needs from the platform's notifications. An interface so the
/// planning logic can be tested without a phone.
abstract class ReminderScheduler {
  /// Asks the user for the right to show notifications; true if granted.
  Future<bool> requestPermission();

  /// Whether notifications may be shown right now.
  Future<bool> hasPermission();

  /// Replaces whatever was scheduled with [reminders].
  Future<void> replaceAll(List<ScheduledReminder> reminders);

  Future<void> cancelAll();
}

const _channelId = 'daily_reminder';
const _channelName = 'Rappel quotidien';

/// Local notifications through flutter_local_notifications.
class LocalNotificationsScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;

  Future<void> _init() => _ready ??= _initOnce();

  Future<void> _initOnce() async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (e) {
      // Falls back to UTC: reminders would then be off by the user's
      // offset, so say so in the log rather than failing silently.
      debugPrint('Reminders: could not read the time zone ($e)');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _android;
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<bool> hasPermission() async {
    await _init();
    final android = _android;
    if (android != null) {
      return await android.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  @override
  Future<void> replaceAll(List<ScheduledReminder> reminders) async {
    await _init();
    await _plugin.cancelAll();
    for (final r in reminders) {
      await _plugin.zonedSchedule(
        id: r.id,
        title: r.title,
        body: r.body,
        scheduledDate: tz.TZDateTime.from(r.at, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // Not exact: a reminder a few minutes late is fine, and an exact
        // alarm needs a special permission the user would have to grant.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}

final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalNotificationsScheduler(),
);
