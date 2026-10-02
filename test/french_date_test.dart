import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/format/french_date.dart';
import 'package:sudur/core/memorization/review_calendar.dart';

void main() {
  test('frenchDateLabel capitalizes the weekday', () {
    expect(frenchDateLabel(DateTime(2026, 9, 29)), 'Mardi 29 septembre');
  });

  test('frenchRelativeDay says today, tomorrow, then the full date', () {
    final today = DateTime(2026, 10, 2, 15);
    expect(frenchRelativeDay(DateTime(2026, 10, 2, 1), today), "aujourd'hui");
    expect(frenchRelativeDay(DateTime(2026, 10, 3, 23), today), 'demain');
    expect(frenchRelativeDay(DateTime(2026, 10, 5), today), 'lundi 5 octobre');
  });

  test('daysBetween is exact across the autumn clock change', () {
    // France switches back to winter time on 25 October 2026: that day has
    // 25 hours, so local-midnight subtraction would say 0 days.
    expect(daysBetween(DateTime(2026, 10, 24), DateTime(2026, 10, 25)), 1);
    expect(daysBetween(DateTime(2026, 10, 25), DateTime(2026, 10, 26)), 1);
    expect(daysBetween(DateTime(2026, 10, 2), DateTime(2026, 10, 2, 23)), 0);
    expect(daysBetween(DateTime(2026, 10, 5), DateTime(2026, 10, 2)), -3);
  });

  test('capitalizeFirst tolerates an empty string', () {
    expect(capitalizeFirst(''), '');
    expect(capitalizeFirst('demain'), 'Demain');
  });
}
