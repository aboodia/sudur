import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/mastery.dart';
import 'package:sudur/features/revision/widgets/mastery_widgets.dart';

void main() {
  testWidgets('every non-empty level is drawn with a real size', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: MasteryBar(
              counts: MasteryCounts(weak: 1, medium: 2, solid: 5),
              height: 12,
            ),
          ),
        ),
      ),
    );

    final segments = find.descendant(
      of: find.byType(MasteryBar),
      matching: find.byType(ColoredBox),
    );
    expect(segments, findsNWidgets(3));
    for (final e in segments.evaluate()) {
      final size = tester.getSize(find.byElementPredicate((x) => x == e));
      expect(size.height, 12, reason: 'a collapsed segment is invisible');
      expect(size.width, greaterThan(0));
    }
    // Widths follow the counts: 1 : 2 : 5.
    final widths = [
      for (final e in segments.evaluate())
        tester.getSize(find.byElementPredicate((x) => x == e)).width,
    ];
    expect(widths[1] / widths[0], closeTo(2, 0.01));
    expect(widths[2] / widths[0], closeTo(5, 0.01));
  });

  testWidgets('an empty bar is a plain track', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: MasteryBar(counts: MasteryCounts(), height: 8)),
      ),
    );
    final track = find.descendant(
      of: find.byType(MasteryBar),
      matching: find.byType(ColoredBox),
    );
    expect(track, findsOneWidget);
    expect(tester.getSize(track).height, 8);
  });
}
