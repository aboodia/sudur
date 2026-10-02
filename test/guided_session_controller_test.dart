import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/features/memorization/session_controller.dart';

// Same in-memory-DB pattern as the rest of the test suite.
ProviderContainer _freshContainer() => ProviderContainer(
  overrides: [
    appDatabaseProvider.overrideWithValue(
      AppDatabase.forTesting(NativeDatabase.memory()),
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'startOrResume starts a fresh passage when none is in progress',
    () async {
      final container = _freshContainer();
      addTearDown(container.dispose);
      final notifier = container.read(guidedSessionProvider.notifier);

      await notifier.startOrResume();
      final state = container.read(guidedSessionProvider);

      expect(state.isLoaded, isTrue);
      expect(state.isFinished, isFalse);
      expect(state.passage, isNotNull);
      expect(state.stepIndex, stepDiscover);
      expect(state.currentAyah, state.passage!.ayahStart);
    },
  );

  test('startOrResume picks the interrupted passage back up, at its saved step', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(guidedSessionProvider.notifier);

    await notifier.startOrResume();
    await notifier.finishDiscovering();
    final passage = container.read(guidedSessionProvider).passage!;

    // Simulate reopening the app: a fresh container/provider over the same DB.
    final reopened = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(
          container.read(appDatabaseProvider),
        ),
      ],
    );
    addTearDown(reopened.dispose);
    await reopened.read(guidedSessionProvider.notifier).startOrResume();
    final resumed = reopened.read(guidedSessionProvider);

    expect(resumed.passage!.id, passage.id);
    expect(resumed.stepIndex, stepRepeat);
  });

  test('the full happy path walks Découvrir -> Répéter -> Masquer -> Réciter -> Enchaîner -> fini', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(guidedSessionProvider.notifier);

    await notifier.startOrResume();
    final passage = container.read(guidedSessionProvider).passage!;
    final ayahCount = passage.ayahEnd - passage.ayahStart + 1;
    expect(
      ayahCount,
      greaterThanOrEqualTo(2),
      reason: 'the default suggestion should cover a few ayahs',
    );

    await notifier.finishDiscovering();
    expect(container.read(guidedSessionProvider).stepIndex, stepRepeat);
    expect(
      container.read(guidedSessionProvider).currentAyah,
      passage.ayahStart,
    );

    for (var i = 0; i < ayahCount; i++) {
      await notifier.finishRepeatingCurrentAyah();
    }
    expect(container.read(guidedSessionProvider).stepIndex, stepMask);
    expect(
      container.read(guidedSessionProvider).currentAyah,
      passage.ayahStart,
    );

    for (var i = 0; i < ayahCount; i++) {
      await notifier.finishMaskingCurrentAyah();
    }
    expect(container.read(guidedSessionProvider).stepIndex, stepRecite);
    expect(
      container.read(guidedSessionProvider).currentAyah,
      passage.ayahStart,
    );
    expect(
      container.read(guidedSessionProvider).chainStatuses[passage.ayahStart],
      ChainAyahStatus.current,
    );

    for (var ayah = passage.ayahStart; ayah <= passage.ayahEnd; ayah++) {
      await notifier.submitReciteOutcome(ReciteOutcome.clean);
    }
    expect(container.read(guidedSessionProvider).stepIndex, stepChain);
    for (var ayah = passage.ayahStart; ayah <= passage.ayahEnd; ayah++) {
      expect(
        container.read(guidedSessionProvider).chainStatuses[ayah],
        ChainAyahStatus.validated,
      );
    }

    final repo = container.read(memorizationRepositoryProvider);
    final profile = await container.read(currentProfileProvider.future);
    final keys = await repo.memorizedAyahKeys(profile.id);
    expect(keys.length, ayahCount);

    await notifier.finishPassage();
    expect(container.read(guidedSessionProvider).isFinished, isTrue);
    expect(await repo.activeSession(profile.id), isNull);

    // The sitting is logged for the dashboard's time invested.
    final db = container.read(appDatabaseProvider);
    final session = (await db.select(db.studySessionEntries).get()).single;
    expect(session.kind, 'memorization');
    expect(session.ayahCount, ayahCount);
  });

  test('a redo verdict on Réciter sends the ayah back to Masquer, then returns to Réciter', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(guidedSessionProvider.notifier);

    await notifier.startOrResume();
    await notifier.finishDiscovering();
    final passage = container.read(guidedSessionProvider).passage!;
    final ayahCount = passage.ayahEnd - passage.ayahStart + 1;
    for (var i = 0; i < ayahCount; i++) {
      await notifier.finishRepeatingCurrentAyah();
    }
    for (var i = 0; i < ayahCount; i++) {
      await notifier.finishMaskingCurrentAyah();
    }
    expect(container.read(guidedSessionProvider).stepIndex, stepRecite);

    await notifier.submitReciteOutcome(ReciteOutcome.redo);
    var state = container.read(guidedSessionProvider);
    expect(state.stepIndex, stepMask);
    expect(state.isRedoFlow, isTrue);
    expect(state.currentAyah, passage.ayahStart);
    expect(state.chainStatuses[passage.ayahStart], ChainAyahStatus.hesitant);

    // "Je le connais" while in the redo flow returns straight to Réciter
    // for the same ayah, instead of advancing to the next one.
    await notifier.finishMaskingCurrentAyah();
    state = container.read(guidedSessionProvider);
    expect(state.stepIndex, stepRecite);
    expect(state.currentAyah, passage.ayahStart);
    expect(state.isRedoFlow, isFalse);
  });

  test('revealing a masked word marks it fragile', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(guidedSessionProvider.notifier);

    await notifier.startOrResume();
    await notifier.finishDiscovering();

    notifier.revealWord(0);
    expect(container.read(guidedSessionProvider).fragileIndices, {0});
    expect(container.read(guidedSessionProvider).revealedIndices, {0});
  });
}
