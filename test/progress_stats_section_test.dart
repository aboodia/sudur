import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/stats/progress_stats_provider.dart';
import 'package:sudur/features/home/widgets/progress_stats_section.dart';
import 'package:sudur/l10n/app_localizations.dart';

Future<void> _pump(WidgetTester tester, ProgressStats stats) async {
  tester.view.physicalSize = const Size(900, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [progressStatsProvider.overrideWith((ref) => stats)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ProgressStatsSection()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('shows the six figures with French formatting', (tester) async {
    await _pump(
      tester,
      const ProgressStats(
        memorizedAyahs: 29,
        completedSurahs: 6,
        juz: 1.26,
        retention: 0.75,
        streakDays: 3,
        studyTime: Duration(minutes: 125),
      ),
    );

    expect(find.text('Statistiques de progression'), findsOneWidget);
    expect(find.text('29'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('1,3'), findsOneWidget);
    expect(find.text('75 %'), findsOneWidget);
    expect(find.text('3 j'), findsOneWidget);
    expect(find.text('2 h 05'), findsOneWidget);
  });

  testWidgets('without any review it says so instead of inventing a rate', (
    tester,
  ) async {
    await _pump(
      tester,
      const ProgressStats(
        memorizedAyahs: 0,
        completedSurahs: 0,
        juz: 0,
        retention: null,
        streakDays: 0,
        studyTime: Duration.zero,
      ),
    );

    expect(find.text('—'), findsOneWidget);
    expect(find.text('pas encore de révision'), findsOneWidget);
    expect(find.text('0 min'), findsOneWidget);
    // Zero stays a plain 0 (the streak and the other tiles read "0 j" / "0 min").
    expect(find.text('0'), findsWidgets);
  });
}
