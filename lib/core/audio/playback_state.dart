/// The 4 repeat states of the "lecteur audio étendu" (Brique 1), reused
/// directly by the Mémorisation brique's répétition guidée (Brique 3):
///
/// - [off] : lecture continue, un ayah après l'autre.
/// - [repeatAyah] : boucle indéfiniment sur l'ayah courant.
/// - [repeatRange] : boucle sur une plage d'ayahs choisie par l'utilisateur.
/// - [repeatEachAyahNTimes] : rejoue chaque ayah N fois avant de passer au
///   suivant — mode répétition pour la mémorisation.
/// - [repeatThenStop] : joue l'ayah courant N fois puis s'arrête, sans
///   jamais passer au suivant — l'étape Répéter de la Mémorisation.
enum RepeatMode {
  off,
  repeatAyah,
  repeatRange,
  repeatEachAyahNTimes,
  repeatThenStop,
}

class ReadingPlaybackState {
  const ReadingPlaybackState({
    this.surahNumber,
    this.ayahNumber,
    this.isPlaying = false,
    this.isLoading = false,
    this.speed = 1.0,
    this.repeatMode = RepeatMode.off,
    this.reciterId = 'alafasy',
    this.repeatRangeStart,
    this.repeatRangeEnd,
    this.repeatTarget = 3,
    this.repeatProgress = 0,
  });

  final int? surahNumber;
  final int? ayahNumber;
  final bool isPlaying;
  final bool isLoading;
  final double speed;
  final RepeatMode repeatMode;
  final String reciterId;
  final int? repeatRangeStart;
  final int? repeatRangeEnd;

  /// N for [RepeatMode.repeatEachAyahNTimes].
  final int repeatTarget;

  /// How many times the current ayah has already been repeated (État 4).
  final int repeatProgress;

  bool get hasCurrentAyah => surahNumber != null && ayahNumber != null;

  ReadingPlaybackState copyWith({
    int? surahNumber,
    int? ayahNumber,
    bool? isPlaying,
    bool? isLoading,
    double? speed,
    RepeatMode? repeatMode,
    String? reciterId,
    int? repeatRangeStart,
    int? repeatRangeEnd,
    int? repeatTarget,
    int? repeatProgress,
  }) {
    return ReadingPlaybackState(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      speed: speed ?? this.speed,
      repeatMode: repeatMode ?? this.repeatMode,
      reciterId: reciterId ?? this.reciterId,
      repeatRangeStart: repeatRangeStart ?? this.repeatRangeStart,
      repeatRangeEnd: repeatRangeEnd ?? this.repeatRangeEnd,
      repeatTarget: repeatTarget ?? this.repeatTarget,
      repeatProgress: repeatProgress ?? this.repeatProgress,
    );
  }
}
