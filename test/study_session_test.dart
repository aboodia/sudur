import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/study_session.dart';

void main() {
  test('a normal sitting is kept as is', () {
    expect(
      cappedStudyDuration(const Duration(minutes: 12)),
      const Duration(minutes: 12),
    );
  });

  test('a sitting left open overnight is capped', () {
    expect(
      cappedStudyDuration(const Duration(hours: 9)),
      maxStudySessionDuration,
    );
  });
}
