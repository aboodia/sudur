import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../quran_text/quran_text_repository.dart';
import 'ayah_audio_cache.dart';
import 'playback_plan.dart';
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
      isLoading:
          playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering,
    );
    if (playerState.processingState == ProcessingState.completed) {
      _onAyahCompleted();
    }
  }

  /// Prépare le mini-lecteur pour un ayah sans lancer sa lecture — utilisé
  /// à l'entrée sur un écran de lecture pour que la barre soit visible
  /// tout de suite, prête à jouer, sans attendre qu'on clique un ayah.
  /// N'écrase jamais une lecture en cours (ou en chargement) ailleurs dans
  /// l'app : elle prime sur la simple ouverture d'un nouvel écran. En
  /// revanche, un ayah simplement à l'arrêt (en pause, ou resté là après une
  /// session de Mémorisation) est remplacé : ouvrir une sourate cale le
  /// lecteur dessus.
  void prepare(int surahNumber, int ayahNumber) {
    if (state.hasCurrentAyah && (state.isPlaying || state.isLoading)) return;
    _hasLoadedSource = false;
    state = state.copyWith(surahNumber: surahNumber, ayahNumber: ayahNumber);
  }

  /// Sélectionne un ayah sans lancer sa lecture — utilisé quand on tape un
  /// mot dans la vue Mushaf pour choisir/surligner un verset : ça ne doit
  /// pas déclencher le son tout seul, l'utilisateur reste maître d'appuyer
  /// sur play dans le mini-lecteur. Contrairement à [prepare], remplace
  /// toujours l'ayah courant (choix explicite de l'utilisateur) et coupe
  /// toute lecture en cours d'un autre ayah.
  Future<void> select(int surahNumber, int ayahNumber) async {
    if (state.surahNumber == surahNumber && state.ayahNumber == ayahNumber) {
      return;
    }
    await _player.stop();
    _hasLoadedSource = false;
    state = state.copyWith(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      isPlaying: false,
      isLoading: false,
      repeatProgress: 0,
    );
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
      final cachedPath = await ref
          .read(ayahAudioCacheProvider)
          .localPathFor(url);
      if (cachedPath != null) {
        await _player.setFilePath(cachedPath);
      } else {
        await _player.setUrl(url);
      }
      _hasLoadedSource = true;
      await _player.setSpeed(state.speed);
      await _player.play();
    } catch (_) {
      // Network/CDN failure: surface as "not playing" rather than crash the
      // reading screen; the user can retry.
      state = state.copyWith(isPlaying: false, isLoading: false);
    }
  }

  /// Live playback position/duration — kept as raw streams rather than in
  /// [ReadingPlaybackState] since they tick many times a second and would
  /// otherwise force a full state rebuild on every frame. Used by the
  /// Découvrir step's elapsed/total time readout.
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

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
    // The whole app scope can be torn down while the player is stopping.
    if (!ref.mounted) return;
    state = state.copyWith(isPlaying: false);
  }

  /// Leaving a guided Mémorisation session: stop, and drop its special
  /// repeat mode, so the Reading mini-player isn't left looping a range or
  /// stopping after N plays.
  Future<void> endGuidedListening() async {
    if (!ref.mounted) return;
    await stop();
    if (!ref.mounted) return;
    setNoRepeat();
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

  /// Repeat the current ayah [n] times (n extra plays after the first, so
  /// n+1 plays total) before moving on — the mini-player's "1" / "2" / "3"
  /// options.
  void setRepeatCount(int n) {
    state = state.copyWith(
      repeatMode: RepeatMode.repeatEachAyahNTimes,
      repeatTarget: n,
      repeatProgress: 0,
    );
  }

  /// Play the current ayah [repeats] + 1 times, then stop on it — Répéter
  /// must never run on into the following verse.
  void setRepeatThenStop(int repeats) {
    state = state.copyWith(
      repeatMode: RepeatMode.repeatThenStop,
      repeatTarget: repeats,
      repeatProgress: 0,
    );
  }

  /// Repeat the current ayah forever — the mini-player's "boucle infinie"
  /// option.
  void setInfiniteRepeat() {
    state = state.copyWith(
      repeatMode: RepeatMode.repeatAyah,
      repeatProgress: 0,
    );
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

  /// Skip to the next ayah — crossing into the next sourate after the
  /// last ayah of this one.
  Future<void> next() async {
    if (!state.hasCurrentAyah) return;
    final repo = await ref.read(quranTextProvider.future);
    final target = ayahAfter(
      state.surahNumber!,
      state.ayahNumber!,
      ayahCount: repo.surah(state.surahNumber!).ayahs.length,
    );
    if (target == null) return;
    await playFrom(target.surah, target.ayah);
  }

  Future<void> previous() async {
    if (!state.hasCurrentAyah) return;
    if (state.ayahNumber! > 1) {
      await playFrom(state.surahNumber!, state.ayahNumber! - 1);
    }
  }

  Future<void> _onAyahCompleted() async {
    if (!state.hasCurrentAyah) return;
    final repo = await ref.read(quranTextProvider.future);
    final action = afterAyahCompleted(
      state,
      ayahCount: repo.surah(state.surahNumber!).ayahs.length,
    );

    switch (action) {
      case ReplayAyah(:final repeatProgress):
        state = state.copyWith(repeatProgress: repeatProgress);
        await _loadAndPlayCurrent();
      case PlayAyah(:final surah, :final ayah, :final repeatProgress):
        state = state.copyWith(
          surahNumber: surah,
          ayahNumber: ayah,
          repeatProgress: repeatProgress,
        );
        await _loadAndPlayCurrent();
      case StopPlayback(:final lineUp):
        // Truly stop (the player otherwise keeps reporting `playing` on a
        // finished source) and drop the loaded source, so that play loads
        // the lined-up ayah instead of "resuming" the finished one.
        await _player.stop();
        _hasLoadedSource = false;
        state = state.copyWith(
          surahNumber: lineUp?.surah,
          ayahNumber: lineUp?.ayah,
          isPlaying: false,
          isLoading: false,
          repeatProgress: 0,
        );
    }
  }
}

final audioPlaybackProvider =
    NotifierProvider<AudioPlaybackController, ReadingPlaybackState>(
      AudioPlaybackController.new,
    );
