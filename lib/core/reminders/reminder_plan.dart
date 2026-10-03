import '../memorization/review_calendar.dart';

// Which reminders to schedule and when — pure logic, no Flutter and no
// platform. The app cannot run in the background, so the next few reminders
// are planned each time it is opened or the user studies; they are meant to
// be gentle: never on a day the user said they are not available, never on
// a day they already studied, and softer after a few days away.

/// How many reminders are kept scheduled ahead.
const reminderCount = 7;

/// How far ahead, in days, reminders are looked for.
const reminderHorizonDays = 14;

enum ReminderKind {
  /// The usual invitation.
  standard,

  /// The user has been away for a few days: no reproach, a shorter session
  /// to get back into it.
  comeBack,
}

class PlannedReminder {
  const PlannedReminder(this.at, this.kind);

  final DateTime at;
  final ReminderKind kind;

  @override
  bool operator ==(Object other) =>
      other is PlannedReminder && other.at == at && other.kind == kind;

  @override
  int get hashCode => Object.hash(at, kind);

  @override
  String toString() => 'PlannedReminder($at, ${kind.name})';
}

/// The reminders to keep scheduled, soonest first.
///
/// One per available day at [hour]:[minute] (bit 0 = Monday in
/// [availableDaysMask]), from today on: a time already past is skipped, and
/// so is today if [lastActivity] is today. A reminder falling two or more
/// days after the last activity is a [ReminderKind.comeBack].
List<PlannedReminder> planReminders({
  required DateTime now,
  required int hour,
  required int minute,
  required int availableDaysMask,
  DateTime? lastActivity,
}) {
  final today = dateOnly(now);
  final lastDay = lastActivity == null ? null : dateOnly(lastActivity);
  final planned = <PlannedReminder>[];

  for (var i = 0; i < reminderHorizonDays; i++) {
    if (planned.length == reminderCount) break;
    // The constructor, not an addition of 24 h: a clock change would
    // otherwise move the reminder an hour.
    final day = DateTime(today.year, today.month, today.day + i);
    final available = availableDaysMask & (1 << (day.weekday - 1)) != 0;
    if (!available) continue;

    final at = DateTime(day.year, day.month, day.day, hour, minute);
    if (!at.isAfter(now)) continue;
    if (lastDay != null && day == lastDay) continue;

    final awayDays = lastDay == null ? 0 : daysBetween(lastDay, day);
    planned.add(
      PlannedReminder(
        at,
        awayDays >= 2 ? ReminderKind.comeBack : ReminderKind.standard,
      ),
    );
  }
  return planned;
}
