import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../quran_text/quran_text_repository.dart';
import 'playback_state.dart';
import 'reciter.dart';

/// Drives ayah-by-ayah playback for the Écran de lecture. Owns a single
/// [AudioPlayer] and streams one ayah URL at a time (rather than a
/// pre-built playlist) so the 4 repeat states can decide what plays next
/// after every completion — including on-the-fly range/reciter changes.
class AudioPlaybackController extends Notifier<ReadingPlaybackState> {
  late final AudioPlayer _player;

  @override
  ReadingPlaybackState build() {
    _player = AudioPlayer();
    _configureSession();
    _player.playerStateStream.listen(_onPlayerStateChanged);
    ref.onDispose(_player.dispose);
    return const ReadingPlaybackState();
  }

  Future<void> _configureSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  void _onPlayerStateChanged(PlayerState playerState) {
    state = state.copyWith(
      isPlaying: playerState.playing,
      isLoading: playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering,
    );
    if (playerState.processingState == ProcessingState.completed) {
      _onAyahCompleted();
    }
  }

  Future<void> playFrom(int surahNumber, int ayahNumber) async {
    state = state.copyWith(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      repeatProgress: 0,
    );
    await _loadAndPlayCurrent();
  }

  Future<void> _loadAndPlayCurrent() async {
    if (!state.hasCurrentAyah) return;
    final repo = await ref.read(quranTextProvider.future);
    final global = repo.globalAyahNumber(state.surahNumber!, state.ayahNumber!);
    final url = ayahAudioUrl(reciterById(state.reciterId), global);
    try {
      await _player.setUrl(url);
      await _player.setSpeed(state.speed);
      await _player.play();
    } catch (_) {
      // Network/CDN failure: surface as "not playing" rather than crash the
      // reading screen; the user can retry.
      state = state.copyWith(isPlaying: false, isLoading: false);
    }
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.play();

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _player.setSpeed(speed);
  }

  void setReciter(String reciterId) {
    state = state.copyWith(reciterId: reciterId);
    if (state.isPlaying || state.isLoading) {
      _loadAndPlayCurrent();
    }
  }

  void cycleRepeatMode() {
    final next = switch (state.repeatMode) {
      RepeatMode.off => RepeatMode.repeatAyah,
      RepeatMode.repeatAyah => RepeatMode.repeatRange,
      RepeatMode.repeatRange => RepeatMode.repeatEachAyahNTimes,
      RepeatMode.repeatEachAyahNTimes => RepeatMode.off,
    };
    state = state.copyWith(repeatMode: next, repeatProgress: 0);
  }

  void setRepeatRange(int startAyah, int endAyah) {
    state = state.copyWith(
      repeatMode: RepeatMode.repeatRange,
      repeatRangeStart: startAyah,
      repeatRangeEnd: endAyah,
      repeatProgress: 0,
    );
  }

  void setRepeatTarget(int n) {
    state = state.copyWith(repeatTarget: n);
  }

  Future<void> next() async {
    final repo = await ref.read(quranTextProvider.future);
    if (!state.hasCurrentAyah) return;
    final surah = repo.surah(state.surahNumber!);
    if (state.ayahNumber! < surah.ayahs.length) {
      await playFrom(state.surahNumber!, state.ayahNumber! + 1);
    }
  }

  Future<void> previous() async {
    if (!state.hasCurrentAyah) return;
    if (state.ayahNumber! > 1) {
      await playFrom(state.surahNumber!, state.ayahNumber! - 1);
    }
  }

  Future<void> _onAyahCompleted() async {
    switch (state.repeatMode) {
      case RepeatMode.off:
        await next();
      case RepeatMode.repeatAyah:
        await _loadAndPlayCurrent();
      case RepeatMode.repeatRange:
        final start = state.repeatRangeStart ?? state.ayahNumber!;
        final end = state.repeatRangeEnd ?? state.ayahNumber!;
        final nextAyah = (state.ayahNumber ?? start) + 1;
        if (nextAyah > end) {
          state = state.copyWith(ayahNumber: start);
        } else {
          state = state.copyWith(ayahNumber: nextAyah);
        }
        await _loadAndPlayCurrent();
      case RepeatMode.repeatEachAyahNTimes:
        final progress = state.repeatProgress + 1;
        if (progress >= state.repeatTarget) {
          state = state.copyWith(repeatProgress: 0);
          await next();
        } else {
          state = state.copyWith(repeatProgress: progress);
          await _loadAndPlayCurrent();
        }
    }
  }
}

final audioPlaybackProvider =
    NotifierProvider<AudioPlaybackController, ReadingPlaybackState>(
  AudioPlaybackController.new,
);
