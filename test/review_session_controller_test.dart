import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/database/review_repository.dart';
import 'package:sudur/core/review/spaced_repetition.dart';
import 'package:sudur/features/review/review_session_controller.dart';

// Same in-memory-DB pattern as memorization_session_controller_test.dart.
ProviderContainer _freshContainer() => ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
      ],
    );

Future<String> _seedDueUnit(
  ProviderContainer container, {
  required String id,
  required int circle,
  required DateTime nextReviewDueAt,
}) async {
  final db = container.read(appDatabaseProvider);
  final now = DateTime.now();
  await db.into(db.memorizationUnits).insert(
        MemorizationUnitsCompanion.insert(
          id: id,
          profileId: localProfileId,
          surahNumber: 1,
          startAyah: 1,
          endAyah: 2,
          status: const Value('memorized'),
          masteryLevel: const Value('medium'),
          circle: Value(circle),
          lastReviewedAt: Value(now),
          nextReviewDueAt: Value(nextReviewDueAt),
          createdAt: now,
          updatedAt: now,
        ),
      );
  return id;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('rate(solid) advances the circle and clears the unit from dueUnits', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    await container.read(currentProfileProvider.future); // creates the 'local' profile row (FK target)

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await _seedDueUnit(container, id: 'u1', circle: 1, nextReviewDueAt: yesterday);

    final due = await container.read(dueUnitsProvider.future);
    expect(due.map((u) => u.id), ['u1']);

    final notifier = container.read(reviewSessionProvider.notifier);
    notifier.startSession(due);
    expect(container.read(reviewSessionProvider).stage, ReviewStage.recalling);

    notifier.reveal();
    expect(container.read(reviewSessionProvider).stage, ReviewStage.revealed);

    await notifier.rate(ReviewRating.solid);
    expect(container.read(reviewSessionProvider).stage, ReviewStage.complete);

    final dueAfter = await container.read(dueUnitsProvider.future);
    expect(dueAfter, isEmpty);

    final db = container.read(appDatabaseProvider);
    final updated = await (db.select(db.memorizationUnits)..where((u) => u.id.equals('u1'))).getSingle();
    expect(updated.circle, 2);
    expect(updated.masteryLevel, 'solid');
    expect(updated.nextReviewDueAt!.isAfter(DateTime.now().add(const Duration(days: 6))), isTrue);

    final history = await (db.select(db.reviewHistoryEntries)..where((h) => h.unitId.equals('u1'))).get();
    expect(history, hasLength(1));
    expect(history.single.result, 'success');
    expect(history.single.circleBefore, 1);
    expect(history.single.circleAfter, 2);
  });

  test('rate(weak) reintegrates Cercle 1 and advances to the next unit', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    await container.read(currentProfileProvider.future);

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await _seedDueUnit(container, id: 'u1', circle: 3, nextReviewDueAt: yesterday);
    await _seedDueUnit(container, id: 'u2', circle: 2, nextReviewDueAt: yesterday);

    final due = await container.read(dueUnitsProvider.future);
    expect(due, hasLength(2));

    final notifier = container.read(reviewSessionProvider.notifier);
    notifier.startSession(due);
    notifier.reveal();
    await notifier.rate(ReviewRating.weak);

    var state = container.read(reviewSessionProvider);
    expect(state.currentIndex, 1);
    expect(state.stage, ReviewStage.recalling);

    final db = container.read(appDatabaseProvider);
    final firstUnit = await (db.select(db.memorizationUnits)..where((u) => u.id.equals('u1'))).getSingle();
    expect(firstUnit.circle, 1);
    expect(firstUnit.masteryLevel, 'weak');

    notifier.reveal();
    await notifier.rate(ReviewRating.medium);
    state = container.read(reviewSessionProvider);
    expect(state.stage, ReviewStage.complete);
  });

  test('an empty due queue is loaded, not stuck pending', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    await container.read(currentProfileProvider.future);

    final notifier = container.read(reviewSessionProvider.notifier);
    notifier.startSession(const []);

    final state = container.read(reviewSessionProvider);
    expect(state.isLoaded, isTrue);
    expect(state.units, isEmpty);
  });
}
