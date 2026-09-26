import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/database/app_database.dart';
import 'package:wird/features/memorization/memorization_session_controller.dart';

// Each test gets its own in-memory AppDatabase — see test/widget_test.dart
// for why the real appDatabaseProvider (an on-disk file) isn't safe here.
ProviderContainer _freshContainer() => ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
      ],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('advances listening -> repeating -> masking(0,1,2) -> selfAssessing', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memorizationSessionProvider.notifier);

    await notifier.startSession(1, 1, 2);
    expect(container.read(memorizationSessionProvider).stage, MemorizationStage.listening);

    notifier.advanceStage();
    expect(container.read(memorizationSessionProvider).stage, MemorizationStage.repeating);

    notifier.advanceStage();
    expect(container.read(memorizationSessionProvider).stage, MemorizationStage.masking);
    expect(container.read(memorizationSessionProvider).maskLevel, 0);

    notifier.advanceStage();
    expect(container.read(memorizationSessionProvider).maskLevel, 1);

    notifier.advanceStage();
    expect(container.read(memorizationSessionProvider).maskLevel, 2);

    notifier.advanceStage();
    expect(container.read(memorizationSessionProvider).stage, MemorizationStage.selfAssessing);
  });

  test('markNeedsMoreWork resets to listening on the same ayah', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memorizationSessionProvider.notifier);

    await notifier.startSession(1, 1, 2);
    notifier.advanceStage();
    notifier.markNeedsMoreWork();

    final state = container.read(memorizationSessionProvider);
    expect(state.stage, MemorizationStage.listening);
    expect(state.currentAyah, 1);
  });

  test('markGotIt moves to the next ayah, then completes the unit on the last one', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memorizationSessionProvider.notifier);

    await notifier.startSession(1, 1, 2);
    await notifier.markGotIt();
    var state = container.read(memorizationSessionProvider);
    expect(state.currentAyah, 2);
    expect(state.stage, MemorizationStage.listening);

    await notifier.markGotIt();
    state = container.read(memorizationSessionProvider);
    expect(state.stage, MemorizationStage.complete);
  });

  test('revealWord adds the index without changing maskLevel', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memorizationSessionProvider.notifier);

    await notifier.startSession(1, 1, 1);
    notifier.advanceStage();
    notifier.advanceStage();
    notifier.revealWord(2);

    final state = container.read(memorizationSessionProvider);
    expect(state.revealedWordIndices, {2});
    expect(state.maskLevel, 0);
  });
}
