import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/reminders/reminder_scheduler.dart';
import 'package:sudur/core/reminders/reminder_settings.dart';
import 'package:sudur/core/reminders/reminder_sync.dart';

import 'helpers/revision_seed.dart';

class _FakeScheduler implements ReminderScheduler {
  _FakeScheduler({this.permission = true});

  final bool permission;
  var cancelled = 0;
  List<ScheduledReminder>? scheduled;

  @override
  Future<bool> requestPermission() async => permission;

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<void> replaceAll(List<ScheduledReminder> reminders) async {
    scheduled = reminders;
  }

  @override
  Future<void> cancelAll() async {
    cancelled++;
    scheduled = null;
  }
}

ProviderContainer _container(_FakeScheduler fake) {
  final base = freshContainer();
  final db = base.read(appDatabaseProvider);
  base.dispose();
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      reminderSchedulerProvider.overrideWithValue(fake),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> sync(ProviderContainer c) async {
    // Let the saved settings load, then run the synchronisation.
    c.read(reminderSettingsProvider);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    c.invalidate(reminderSyncProvider);
    await c.read(reminderSyncProvider.future);
  }

  test('off by default: nothing is scheduled', () async {
    SharedPreferences.setMockInitialValues({});
    final fake = _FakeScheduler();
    final c = _container(fake);
    addTearDown(c.dispose);

    await sync(c);

    expect(fake.scheduled, isNull);
    expect(c.read(reminderSettingsProvider).enabled, isFalse);
  });

  test(
    'enabled: the next reminders are scheduled at the chosen time',
    () async {
      SharedPreferences.setMockInitialValues({
        'reminder.enabled': true,
        'reminder.hour': 7,
        'reminder.minute': 45,
      });
      final fake = _FakeScheduler();
      final c = _container(fake);
      addTearDown(c.dispose);

      await sync(c);

      final scheduled = fake.scheduled!;
      expect(scheduled, isNotEmpty);
      expect(
        scheduled.every((r) => r.at.hour == 7 && r.at.minute == 45),
        isTrue,
      );
      expect(scheduled.every((r) => r.at.isAfter(DateTime.now())), isTrue);
      // Ids are distinct and start at the documented base.
      expect(scheduled.first.id, reminderFirstId);
      expect(scheduled.map((r) => r.id).toSet(), hasLength(scheduled.length));
      expect(scheduled.first.title, 'Sudur');
    },
  );

  test('reminders only fall on the days the user is available', () async {
    SharedPreferences.setMockInitialValues({'reminder.enabled': true});
    final fake = _FakeScheduler();
    final c = _container(fake);
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    // Wednesday only (bit 2).
    await c
        .read(userProfileRepositoryProvider)
        .updateProfile(id: profile.id, availableDaysMask: 4);
    c.invalidate(currentProfileProvider);

    await sync(c);

    expect(
      fake.scheduled!.every((r) => r.at.weekday == DateTime.wednesday),
      isTrue,
    );
  });

  test('a refused permission schedules nothing', () async {
    SharedPreferences.setMockInitialValues({'reminder.enabled': true});
    final fake = _FakeScheduler(permission: false);
    final c = _container(fake);
    addTearDown(c.dispose);

    await sync(c);

    expect(fake.scheduled, isNull);
    expect(fake.cancelled, greaterThan(0));
  });

  test('having studied today, the first reminder is not today', () async {
    SharedPreferences.setMockInitialValues({
      'reminder.enabled': true,
      'reminder.hour': 23,
      'reminder.minute': 59,
    });
    final fake = _FakeScheduler();
    final c = _container(fake);
    addTearDown(c.dispose);
    await seedAyah(
      c,
      surah: 67,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 3)),
    );
    // Studying today is an entry in the activity log.
    final profile = await c.read(currentProfileProvider.future);
    final db = c.read(appDatabaseProvider);
    await db
        .into(db.reviewLogEntries)
        .insert(
          ReviewLogEntriesCompanion.insert(
            id: 'today',
            profileId: profile.id,
            surahNumber: 67,
            ayahNumber: 1,
            kind: 'memorize',
            outcome: 'clean',
            occurredAt: DateTime.now(),
          ),
        );

    await sync(c);

    final now = DateTime.now();
    final first = fake.scheduled!.first.at;
    expect(
      DateTime(
        first.year,
        first.month,
        first.day,
      ).isAfter(DateTime(now.year, now.month, now.day)),
      isTrue,
    );
  });

  test('turning the reminder off cancels what was scheduled', () async {
    SharedPreferences.setMockInitialValues({'reminder.enabled': true});
    final fake = _FakeScheduler();
    final c = _container(fake);
    addTearDown(c.dispose);
    await sync(c);
    expect(fake.scheduled, isNotNull);

    await c.read(reminderSettingsProvider.notifier).setEnabled(false);
    c.invalidate(reminderSyncProvider);
    await c.read(reminderSyncProvider.future);

    expect(fake.scheduled, isNull);
  });

  test('the saved time and switch survive a restart', () async {
    SharedPreferences.setMockInitialValues({});
    final fake = _FakeScheduler();
    final first = _container(fake);
    first.read(reminderSettingsProvider);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final controller = first.read(reminderSettingsProvider.notifier);
    await controller.setEnabled(true);
    await controller.setTime(6, 15);
    first.dispose();

    final second = _container(fake);
    addTearDown(second.dispose);
    second.read(reminderSettingsProvider);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final s = second.read(reminderSettingsProvider);
    expect(s.enabled, isTrue);
    expect(s.hour, 6);
    expect(s.minute, 15);
  });
}
