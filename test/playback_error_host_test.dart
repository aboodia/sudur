import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/app/app.dart';
import 'package:sudur/app/playback_error_host.dart';
import 'package:sudur/core/audio/audio_playback_controller.dart';
import 'package:sudur/core/audio/playback_state.dart';

/// A controller that plays nothing: it only lets the test report failures.
class _FakePlayback extends AudioPlaybackController {
  @override
  ReadingPlaybackState build() => const ReadingPlaybackState();

  void fail() =>
      state = state.copyWith(playbackFailures: state.playbackFailures + 1);

  void selectAyah() => state = state.copyWith(surahNumber: 1, ayahNumber: 1);
}

Future<ProviderContainer> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [audioPlaybackProvider.overrideWith(_FakePlayback.new)],
      child: PlaybackErrorHost(
        child: MaterialApp(
          scaffoldMessengerKey: appMessengerKey,
          home: const Scaffold(body: Text('Lecture')),
        ),
      ),
    ),
  );
  await tester.pump();
  return ProviderScope.containerOf(tester.element(find.text('Lecture')));
}

void main() {
  testWidgets('a failed playback is told to the user, with a way out', (
    tester,
  ) async {
    final container = await _pump(tester);
    expect(find.byType(SnackBar), findsNothing);

    (container.read(audioPlaybackProvider.notifier) as _FakePlayback).fail();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text(
        "Impossible de lire cet audio sans connexion. Télécharge-le d'avance quand tu auras internet.",
      ),
      findsOneWidget,
    );
    expect(find.text('Télécharger'), findsOneWidget);
  });

  testWidgets('every failure is told, not only the first', (tester) async {
    final container = await _pump(tester);
    final fake =
        container.read(audioPlaybackProvider.notifier) as _FakePlayback;

    fake.fail();
    await tester.pump(const Duration(milliseconds: 300));
    fake.fail();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    // The second replaces the first: one message at a time.
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('other changes of the player say nothing', (tester) async {
    final container = await _pump(tester);

    (container.read(audioPlaybackProvider.notifier) as _FakePlayback)
        .selectAyah();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(SnackBar), findsNothing);
  });
}
