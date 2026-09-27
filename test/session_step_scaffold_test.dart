import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/features/memorization/widgets/session_step_scaffold.dart';
import 'package:sudur/l10n/app_localizations.dart';

Widget _harness(SessionStepScaffold scaffold) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: scaffold,
  );
}

void main() {
  testWidgets('the first step shows a quit button, not a back button', (
    tester,
  ) async {
    var quit = false;
    await tester.pumpWidget(
      _harness(
        SessionStepScaffold(
          stepIndex: 0,
          stepLabel: 'Découvrir',
          headerLabel: 'AL-MULK · 1-5',
          body: const SizedBox(),
          bottomBar: const SizedBox(),
          onQuit: () => quit = true,
        ),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.text('Étape 1 sur 5 · Découvrir'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    expect(quit, isTrue);
  });

  testWidgets('a later step shows a back button, not a quit button', (
    tester,
  ) async {
    var back = false;
    await tester.pumpWidget(
      _harness(
        SessionStepScaffold(
          stepIndex: 2,
          stepLabel: 'Masquer',
          headerLabel: 'AL-MULK · 1-5',
          body: const SizedBox(),
          bottomBar: const SizedBox(),
          onQuit: () {},
          onBack: () => back = true,
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.text('Étape 3 sur 5 · Masquer'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    expect(back, isTrue);
  });

  testWidgets('no trailing icon is shown when none is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        SessionStepScaffold(
          stepIndex: 0,
          stepLabel: 'Découvrir',
          headerLabel: 'AL-MULK · 1-5',
          body: const SizedBox(),
          bottomBar: const SizedBox(),
          onQuit: () {},
        ),
      ),
    );

    // Only the quit IconButton should exist — no extra trailing control.
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('a provided trailing widget is shown', (tester) async {
    await tester.pumpWidget(
      _harness(
        SessionStepScaffold(
          stepIndex: 0,
          stepLabel: 'Découvrir',
          headerLabel: 'AL-MULK · 1-5',
          body: const SizedBox(),
          bottomBar: const SizedBox(),
          onQuit: () {},
          trailing: const Icon(Icons.tune),
        ),
      ),
    );

    expect(find.byIcon(Icons.tune), findsOneWidget);
  });
}
