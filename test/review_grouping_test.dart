import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/database/app_database.dart';
import 'package:wird/core/review/review_grouping.dart';

MemorizationUnit _unit({required String id, DateTime? nextReviewDueAt}) {
  final now = DateTime.now();
  return MemorizationUnit(
    id: id,
    profileId: 'local',
    surahNumber: 1,
    startAyah: 1,
    endAyah: 1,
    status: 'memorized',
    masteryLevel: 'solid',
    circle: 3,
    lastReviewedAt: now,
    nextReviewDueAt: nextReviewDueAt,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  test('groups units by due date, ignoring the time of day', () {
    final units = [
      _unit(id: 'a', nextReviewDueAt: DateTime(2026, 3, 5, 8, 30)),
      _unit(id: 'b', nextReviewDueAt: DateTime(2026, 3, 5, 21, 0)),
      _unit(id: 'c', nextReviewDueAt: DateTime(2026, 3, 6, 0, 1)),
    ];

    final grouped = groupByDueDate(units);

    expect(grouped[DateTime(2026, 3, 5)]!.map((u) => u.id), ['a', 'b']);
    expect(grouped[DateTime(2026, 3, 6)]!.map((u) => u.id), ['c']);
  });

  test('units with no due date yet are excluded', () {
    final units = [_unit(id: 'a'), _unit(id: 'b', nextReviewDueAt: DateTime(2026, 3, 5))];

    final grouped = groupByDueDate(units);

    expect(grouped.values.expand((u) => u).map((u) => u.id), ['b']);
  });
}
