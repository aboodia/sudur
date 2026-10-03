import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/reminders/reminder_plan.dart';

void main() {
  // Saturday 3 October 2026, 10:00.
  final now = DateTime(2026, 10, 3, 10);

  List<PlannedReminder> plan({
    DateTime? clock,
    int hour = 20,
    int minute = 0,
    int mask = 127,
    DateTime? last,
  }) => planReminders(
    now: clock ?? now,
    hour: hour,
    minute: minute,
    availableDaysMask: mask,
    lastActivity: last,
  );

  test('one reminder a day at the chosen time, starting today', () {
    final p = plan();
    expect(p, hasLength(reminderCount));
    expect(p.first.at, DateTime(2026, 10, 3, 20));
    expect(p[1].at, DateTime(2026, 10, 4, 20));
    expect(p.last.at, DateTime(2026, 10, 9, 20));
  });

  test('today is skipped once the time has passed', () {
    final p = plan(clock: DateTime(2026, 10, 3, 21));
    expect(p.first.at, DateTime(2026, 10, 4, 20));
  });

  test('a reminder at exactly the current minute is already past', () {
    final p = plan(clock: DateTime(2026, 10, 3, 20));
    expect(p.first.at, DateTime(2026, 10, 4, 20));
  });

  test('having studied today, today is skipped', () {
    final p = plan(last: DateTime(2026, 10, 3, 8));
    expect(p.first.at, DateTime(2026, 10, 4, 20));
    expect(p.first.kind, ReminderKind.standard);
  });

  test('days the user is not available get no reminder', () {
    // Monday to Friday only; today is a Saturday.
    final p = plan(mask: 31);
    expect(p.first.at, DateTime(2026, 10, 5, 20)); // Monday
    expect(p.every((r) => r.at.weekday <= DateTime.friday), isTrue);
    expect(p, hasLength(reminderCount));
  });

  test('no available day at all means no reminder', () {
    expect(plan(mask: 0), isEmpty);
  });

  test('one day since the last study is the usual invitation', () {
    final p = plan(last: DateTime(2026, 10, 2, 9));
    expect(p.first.at, DateTime(2026, 10, 3, 20));
    expect(p.first.kind, ReminderKind.standard);
  });

  test('two days or more away turns the invitation into a gentle comeback', () {
    final p = plan(last: DateTime(2026, 10, 1, 9));
    expect(p.first.at, DateTime(2026, 10, 3, 20));
    expect(p.first.kind, ReminderKind.comeBack);
    expect(p.every((r) => r.kind == ReminderKind.comeBack), isTrue);
  });

  test('never having studied is the usual invitation, not a comeback', () {
    expect(plan().every((r) => r.kind == ReminderKind.standard), isTrue);
  });

  test('the time keeps its hour across a clock change', () {
    // Europe goes back to winter time on 25 October 2026.
    final p = plan(clock: DateTime(2026, 10, 23, 12), hour: 7, minute: 30);
    for (final r in p) {
      expect(r.at.hour, 7);
      expect(r.at.minute, 30);
    }
    expect(p.any((r) => r.at.day == 26), isTrue);
  });

  test('a Friday-only user gets one reminder per week within the horizon', () {
    // Bit 4 = Friday.
    final p = plan(mask: 16);
    expect(p.length, lessThanOrEqualTo(3));
    expect(p.every((r) => r.at.weekday == DateTime.friday), isTrue);
  });
}
