import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/audio/playback_plan.dart';
import 'package:sudur/core/audio/playback_state.dart';

ReadingPlaybackState _state({
  int surah = 112,
  int ayah = 2,
  RepeatMode mode = RepeatMode.off,
  int repeatProgress = 0,
  int repeatTarget = 2,
  int? rangeStart,
  int? rangeEnd,
}) => ReadingPlaybackState(
  surahNumber: surah,
  ayahNumber: ayah,
  repeatMode: mode,
  repeatProgress: repeatProgress,
  repeatTarget: repeatTarget,
  repeatRangeStart: rangeStart,
  repeatRangeEnd: rangeEnd,
);

void main() {
  group('ayahAfter', () {
    test('moves to the next ayah of the same sourate', () {
      expect(ayahAfter(112, 2, ayahCount: 4), (surah: 112, ayah: 3));
    });

    test('crosses into the first ayah of the next sourate', () {
      expect(ayahAfter(112, 4, ayahCount: 4), (surah: 113, ayah: 1));
    });

    test('has nothing after the last ayah of the Quran', () {
      expect(ayahAfter(114, 6, ayahCount: 6), isNull);
    });
  });

  group('afterAyahCompleted', () {
    test('plain playback continues within the sourate', () {
      final action = afterAyahCompleted(_state(ayah: 2), ayahCount: 4);
      expect(action, isA<PlayAyah>());
      expect((action as PlayAyah).ayah, 3);
      expect(action.surah, 112);
    });

    test(
      'plain playback stops at the end of a sourate and lines up the next',
      () {
        final action = afterAyahCompleted(_state(ayah: 4), ayahCount: 4);
        expect(action, isA<StopPlayback>());
        expect((action as StopPlayback).lineUp, (surah: 113, ayah: 1));
      },
    );

    test('at the end of the Quran it stops with nothing to line up', () {
      final action = afterAyahCompleted(
        _state(surah: 114, ayah: 6),
        ayahCount: 6,
      );
      expect(action, isA<StopPlayback>());
      expect((action as StopPlayback).lineUp, isNull);
    });

    test('repeat-ayah replays forever', () {
      final action = afterAyahCompleted(
        _state(mode: RepeatMode.repeatAyah, repeatProgress: 5),
        ayahCount: 4,
      );
      expect(action, isA<ReplayAyah>());
      expect((action as ReplayAyah).repeatProgress, 0);
    });

    test('repeat-N replays until N repeats are done, then moves on', () {
      var action = afterAyahCompleted(
        _state(mode: RepeatMode.repeatEachAyahNTimes, repeatProgress: 1),
        ayahCount: 4,
      );
      expect(action, isA<ReplayAyah>());
      expect((action as ReplayAyah).repeatProgress, 2);

      action = afterAyahCompleted(
        _state(mode: RepeatMode.repeatEachAyahNTimes, repeatProgress: 2),
        ayahCount: 4,
      );
      expect(action, isA<PlayAyah>());
      expect((action as PlayAyah).ayah, 3);
      expect(action.repeatProgress, 0);
    });

    test('repeat-N at the end of a sourate stops instead of running on', () {
      final action = afterAyahCompleted(
        _state(
          ayah: 4,
          mode: RepeatMode.repeatEachAyahNTimes,
          repeatProgress: 2,
        ),
        ayahCount: 4,
      );
      expect(action, isA<StopPlayback>());
      expect((action as StopPlayback).lineUp, (surah: 113, ayah: 1));
    });

    test('repeat-then-stop replays N times then stops on the same ayah', () {
      var action = afterAyahCompleted(
        _state(mode: RepeatMode.repeatThenStop, repeatProgress: 0),
        ayahCount: 4,
      );
      expect(action, isA<ReplayAyah>());
      expect((action as ReplayAyah).repeatProgress, 1);

      action = afterAyahCompleted(
        _state(mode: RepeatMode.repeatThenStop, repeatProgress: 2),
        ayahCount: 4,
      );
      expect(action, isA<StopPlayback>());
      // Stay on the verse: Répéter never moves to the following one.
      expect((action as StopPlayback).lineUp, isNull);
    });

    test('a range loops back to its start after its last ayah', () {
      final inside = afterAyahCompleted(
        _state(
          ayah: 2,
          mode: RepeatMode.repeatRange,
          rangeStart: 1,
          rangeEnd: 3,
        ),
        ayahCount: 7,
      );
      expect((inside as PlayAyah).ayah, 3);

      final atEnd = afterAyahCompleted(
        _state(
          ayah: 3,
          mode: RepeatMode.repeatRange,
          rangeStart: 1,
          rangeEnd: 3,
        ),
        ayahCount: 7,
      );
      expect((atEnd as PlayAyah).ayah, 1);
    });
  });
}
