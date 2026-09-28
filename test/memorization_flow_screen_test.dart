// Regression test for a crash found via manual on-device testing: the very
// first screen of a guided session (typically Découvrir, but potentially any
// step when resuming) gets mounted synchronously as a direct reaction to
// guidedSessionProvider's own state-notification cascade (its state going
// from "not loaded" to "loaded" inside startOrResume()). If that screen's
// initState synchronously writes to another provider (audioPlaybackProvider,
// to start playback), Riverpod rejects it with "Tried to modify a provider
// while the widget tree was building" — invisible to flutter analyze/unit
// tests, only caught by actually pumping the widget tree.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/features/memorization/memorization_flow_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'a fresh guided session mounts Découvrir without a build-time provider '
    'modification error',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(
              AppDatabase.forTesting(NativeDatabase.memory()),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: MemorizationFlowScreen(),
          ),
        ),
      );

      // Not pumpAndSettle: the mini-player's position/duration streams tick
      // on their own timer once "playing", which would never let the tree
      // settle. A handful of fixed pumps is enough to run the microtask
      // that resumes/starts the session and mounts Découvrir.
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Découvrir'), findsWidgets);
    },
  );
}
