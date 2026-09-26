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

  /// Whether [_player] currently has a source loaded — distinct from
  /// [ReadingPlaybackState.hasCurrentAyah], which [prepare] can make true
  /// without ever touching the player. The mini-player's play button needs
  /// this to know whether pressing play should resume an already-loaded
  /// ayah or actually start loading one for the first time.
  bool _hasLoadedSource = false;

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

  /// Prépare le mini-lecteur pour un ayah sans lancer sa lecture — utilisé
  /// à l'entrée sur un écran de lecture pour que la barre soit visible
  /// tout de suite, prête à jouer, sans attendre qu'on clique un ayah.
  /// N'écrase jamais un ayah déjà courant (en cours de lecture, en pause,
  /// ou déjà préparé ailleurs) : la lecture en tenue ailleurs dans l'app
  /// prime toujours sur la simple ouverture d'un nouvel écran.
  void prepare(int surahNumber, int ayahNumber) {
    if (state.hasCurrentAyah) return;
    _hasLoadedSource = false;
    state = state.copyWith(surahNumber: surahNumber, ayahNumber: ayahNumber);
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
      _hasLoadedSource = true;
      await _player.setSpeed(state.speed);
      await _player.play();
    } catch (_) {
      // Network/CDN failure: surface as "not playing" rather than crash the
      // reading screen; the user can retry.
      state = state.copyWith(isPlaying: false, isLoading: false);
    }
  }

  Future<void> pause() => _player.pause();

  /// Bouton play du mini-lecteur : reprend un ayah déjà chargé (mis en
  /// pause) là où il en était, mais si l'ayah courant vient juste d'être
  /// préparé par [prepare] (jamais chargé dans le player), démarre
  /// vraiment sa lecture au lieu de dégeler un player vide.
  Future<void> resume() {
    if (!_hasLoadedSource && state.hasCurrentAyah) {
      return _loadAndPlayCurrent();
    }
    return _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    _hasLoadedSource = false;
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

  /// No repeat: play each ayah once, then move on — the mini-player's
  /// "Aucune" option.
  void setNoRepeat() {
    state = state.copyWith(repeatMode: RepeatMode.off, repeatProgress: 0);
  }

  /// Repeat the current ayah [n] times before moving on — the mini-player's
  /// "1" / "2" / "3" options.
  void setRepeatCount(int n) {
    state = state.copyWith(
      repeatMode: RepeatMode.repeatEachAyahNTimes,
      repeatTarget: n,
      repeatProgress: 0,
    );
  }

  /// Repeat the current ayah forever — the mini-player's "boucle infinie"
  /// option.
  void setInfiniteRepeat() {
    state = state.copyWith(repeatMode: RepeatMode.repeatAyah, repeatProgress: 0);
  }

  /// Reserved for a future "répéter cette plage" passage-repeat feature in
  /// the Mémorisation brique — not wired to the mini-player's simple
  /// repeat button, which only offers a per-ayah count (see above).
  void setRepeatRange(int startAyah, int endAyah) {
    state = state.copyWith(
      repeatMode: RepeatMode.repeatRange,
      repeatRangeStart: startAyah,
      repeatRangeEnd: endAyah,
      repeatProgress: 0,
    );
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
