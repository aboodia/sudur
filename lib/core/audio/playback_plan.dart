import 'playback_state.dart';

/// Number of sourates in the Quran.
const quranSurahCount = 114;

/// What the player does once the current ayah has finished playing.
sealed class AfterAyah {
  const AfterAyah();
}

/// Play the same ayah again ([repeatProgress] = repeats done so far).
final class ReplayAyah extends AfterAyah {
  const ReplayAyah({required this.repeatProgress});

  final int repeatProgress;
}

/// Move on to another ayah and play it.
final class PlayAyah extends AfterAyah {
  const PlayAyah({
    required this.surah,
    required this.ayah,
    this.repeatProgress = 0,
  });

  final int surah;
  final int ayah;
  final int repeatProgress;
}

/// Stop playing. [lineUp] is the ayah the player should be positioned on,
/// so that pressing play starts there — null means stay on the current one.
final class StopPlayback extends AfterAyah {
  const StopPlayback({this.lineUp});

  final ({int surah, int ayah})? lineUp;
}

/// The ayah after (surah, ayah) in Mushaf order, crossing into the next
/// sourate; null after the very last ayah of the Quran.
({int surah, int ayah})? ayahAfter(
  int surah,
  int ayah, {
  required int ayahCount,
  int surahCount = quranSurahCount,
}) {
  if (ayah < ayahCount) return (surah: surah, ayah: ayah + 1);
  if (surah < surahCount) return (surah: surah + 1, ayah: 1);
  return null;
}

/// What to do when the current ayah of [state] completes. [ayahCount] is
/// the number of ayahs in the current sourate. Pure: no audio involved.
AfterAyah afterAyahCompleted(
  ReadingPlaybackState state, {
  required int ayahCount,
}) {
  final surah = state.surahNumber!;
  final ayah = state.ayahNumber!;

  switch (state.repeatMode) {
    case RepeatMode.repeatAyah:
      return const ReplayAyah(repeatProgress: 0);

    case RepeatMode.repeatRange:
      final start = state.repeatRangeStart ?? ayah;
      final end = state.repeatRangeEnd ?? ayah;
      return PlayAyah(surah: surah, ayah: ayah + 1 > end ? start : ayah + 1);

    case RepeatMode.repeatEachAyahNTimes:
      if (state.repeatProgress < state.repeatTarget) {
        return ReplayAyah(repeatProgress: state.repeatProgress + 1);
      }
      return _advance(surah, ayah, ayahCount);

    case RepeatMode.repeatThenStop:
      if (state.repeatProgress < state.repeatTarget) {
        return ReplayAyah(repeatProgress: state.repeatProgress + 1);
      }
      return const StopPlayback();

    case RepeatMode.off:
      return _advance(surah, ayah, ayahCount);
  }
}

/// Keep going within the sourate; at its end, stop and line up the start
/// of the next sourate so that play continues there (nothing to line up
/// after the last ayah of the Quran).
AfterAyah _advance(int surah, int ayah, int ayahCount) {
  if (ayah < ayahCount) return PlayAyah(surah: surah, ayah: ayah + 1);
  return StopPlayback(lineUp: ayahAfter(surah, ayah, ayahCount: ayahCount));
}
