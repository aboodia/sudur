import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/revision/review_cycle.dart';
import 'package:sudur/core/revision/review_cycle_provider.dart';

import 'helpers/revision_seed.dart';

Future<void> _declare(ProviderContainer c, List<int> surahs) async {
  final profile = await c.read(currentProfileProvider.future);
  final repo = c.read(memorizationRepositoryProvider);
  // Verse counts: Al-Fatiha 7, Al-Baqara 286.
  const counts = {1: 7, 2: 286, 112: 4};
  for (final n in surahs) {
    await repo.markSurahMemorized(profile.id, n, counts[n]!);
  }
}

Future<ProviderContainer> _open(
  List<int> declared, [
  Map<String, Object> prefs = const {},
]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final c = freshContainer();
  await _declare(c, declared);
  c.read(reviewCycleProvider);
  await Future<void>.delayed(const Duration(milliseconds: 50));
  return c;
}

String _day(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('nothing declared, no cycle', () async {
    final c = await _open([]);
    addTearDown(c.dispose);

    expect(await c.read(cyclePoolProvider.future), isEmpty);
    expect(await c.read(cycleTodayProvider.future), isNull);
  });

  test('the pool is the Mushaf pages of the declared sourates', () async {
    final c = await _open([1, 2]);
    addTearDown(c.dispose);

    final pool = await c.read(cyclePoolProvider.future);

    // Al-Fatiha fills page 1 and Al-Baqara runs from page 2 to page 49.
    expect(pool.first, 1);
    expect(pool, contains(2));
    expect(pool, contains(49));
    expect(pool, isNot(contains(50)));
    expect(pool, orderedEquals([...pool]..sort()));
    expect(pool.toSet(), hasLength(pool.length));
  });

  test('verses learned in the parcours are not part of the cycle', () async {
    final c = await _open([1]);
    addTearDown(c.dispose);
    // Al-Mulk's verses are scheduled one by one, not by the cycle.
    await seedAyah(
      c,
      surah: 67,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 3)),
    );

    final declared = await c.read(declaredAyahsProvider.future);

    expect(declared.every((a) => a.surah == 1), isTrue);
    expect(declared, hasLength(7));
  });

  test('a sourate with verses of its own is not also declared', () async {
    final c = await _open([1]);
    addTearDown(c.dispose);
    await seedAyah(
      c,
      surah: 1,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 3)),
    );
    c.invalidate(ayahProgressProvider);

    expect(await c.read(declaredAyahsProvider.future), isEmpty);
  });

  test('the first day gives a share and starts the cycle today', () async {
    final c = await _open([1, 2]);
    addTearDown(c.dispose);

    final today = (await c.read(cycleTodayProvider.future))!;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(today.plan.todayPages, isNotEmpty);
    expect(today.plan.todayPages.first, 1);
    expect(today.doneToday, isFalse);
    final state = c.read(reviewCycleProvider);
    expect(state.start, isNotNull);
    expect(state.days, defaultCycleDays);
  });

  test('completing a share advances the cycle and is done for today', () async {
    final c = await _open([1, 2]);
    addTearDown(c.dispose);
    final before = (await c.read(cycleTodayProvider.future))!;
    final count = before.plan.todayPages.length;

    await c
        .read(reviewCycleProvider.notifier)
        .completePages(count, DateTime.now());
    final after = (await c.read(cycleTodayProvider.future))!;

    expect(after.doneToday, isTrue);
    expect(after.plan.donePages, count);
    // Tomorrow's share starts where today's ended.
    expect(after.plan.todayPages.first, greaterThan(count));
  });

  test('the cycle length can be changed and is kept', () async {
    final c = await _open([1, 2]);
    await c.read(reviewCycleProvider.notifier).setDays(60);
    c.dispose();

    final again = await _open([1, 2], {'cycle.days': 60});
    addTearDown(again.dispose);
    expect(again.read(reviewCycleProvider).days, 60);
  });

  test('a length that is not offered is ignored', () async {
    final c = await _open([1]);
    addTearDown(c.dispose);

    await c.read(reviewCycleProvider.notifier).setDays(7);

    expect(c.read(reviewCycleProvider).days, defaultCycleDays);
  });

  test('a finished cycle begins again on a new day', () async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final c = await _open(
      [1],
      {
        'cycle.start': _day(DateTime.now().subtract(const Duration(days: 5))),
        'cycle.done': 1,
        'cycle.lastDone': _day(yesterday),
      },
    );
    addTearDown(c.dispose);

    final today = (await c.read(cycleTodayProvider.future))!;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    // Al-Fatiha is one page: done yesterday, so a new cycle starts.
    expect(today.plan.finished, isFalse);
    expect(today.plan.todayPages, [1]);
    expect(c.read(reviewCycleProvider).donePages, 0);
  });

  test('a cycle finished today says so instead of starting over', () async {
    final c = await _open(
      [1],
      {
        'cycle.start': _day(DateTime.now()),
        'cycle.done': 1,
        'cycle.lastDone': _day(DateTime.now()),
      },
    );
    addTearDown(c.dispose);

    final today = (await c.read(cycleTodayProvider.future))!;

    expect(today.plan.finished, isTrue);
    expect(today.doneToday, isTrue);
  });
}
