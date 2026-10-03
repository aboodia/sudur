import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio/ayah_audio_cache.dart';
import '../audio/reciter.dart';
import '../mushaf/mushaf_font_cache.dart';
import '../quran_reference/quran_reference_repository.dart';
import '../quran_text/quran_text_repository.dart';
import '../settings/audio_settings.dart';
import 'download_runner.dart';
import 'offline_status.dart';

/// What is on the phone for offline use, and what is being downloaded.
class OfflineState {
  const OfflineState({
    this.loaded = false,
    this.cachedPages = const {},
    this.fontBytes = 0,
    this.cachedAudio = const {},
    this.audioBytes = 0,
    this.fontsProgress,
    this.audioSurah,
    this.audioProgress,
  });

  final bool loaded;

  /// Mushaf pages whose font is on disk.
  final Set<int> cachedPages;
  final int fontBytes;

  /// Audio file names on disk (all reciters).
  final Set<String> cachedAudio;
  final int audioBytes;

  /// Set while the Mushaf fonts are being downloaded.
  final DownloadProgress? fontsProgress;

  /// The sourate whose audio is being downloaded, with its progress.
  final int? audioSurah;
  final DownloadProgress? audioProgress;

  bool get fontsRunning => fontsProgress != null;
  bool get audioRunning => audioSurah != null;
  bool get fontsComplete => cachedPages.length >= MushafFontCache.pageCount;
  int get totalBytes => fontBytes + audioBytes;

  OfflineState copyWith({
    bool? loaded,
    Set<int>? cachedPages,
    int? fontBytes,
    Set<String>? cachedAudio,
    int? audioBytes,
    DownloadProgress? Function()? fontsProgress,
    int? Function()? audioSurah,
    DownloadProgress? Function()? audioProgress,
  }) => OfflineState(
    loaded: loaded ?? this.loaded,
    cachedPages: cachedPages ?? this.cachedPages,
    fontBytes: fontBytes ?? this.fontBytes,
    cachedAudio: cachedAudio ?? this.cachedAudio,
    audioBytes: audioBytes ?? this.audioBytes,
    fontsProgress: fontsProgress != null ? fontsProgress() : this.fontsProgress,
    audioSurah: audioSurah != null ? audioSurah() : this.audioSurah,
    audioProgress: audioProgress != null ? audioProgress() : this.audioProgress,
  );
}

class OfflineController extends Notifier<OfflineState> {
  var _cancelFonts = false;
  var _cancelAudio = false;

  @override
  OfflineState build() {
    Future.microtask(refresh);
    return const OfflineState();
  }

  MushafFontCache get _fonts => ref.read(mushafFontCacheProvider);
  AyahAudioCache get _audio => ref.read(ayahAudioCacheProvider);

  /// Reads what is on disk.
  Future<void> refresh() async {
    final pages = await _fonts.cachedPages();
    final fontBytes = await _fonts.sizeOnDisk();
    final audio = await _audio.cachedFileNames();
    final audioBytes = await _audio.sizeOnDisk();
    if (!ref.mounted) return;
    state = state.copyWith(
      loaded: true,
      cachedPages: pages,
      fontBytes: fontBytes,
      cachedAudio: audio,
      audioBytes: audioBytes,
    );
  }

  // ---- Mushaf fonts

  Future<void> downloadAllFonts() async {
    if (state.fontsRunning) return;
    _cancelFonts = false;
    final missing = [
      for (var p = 1; p <= MushafFontCache.pageCount; p++)
        if (!state.cachedPages.contains(p)) p,
    ];
    state = state.copyWith(
      fontsProgress: () =>
          DownloadProgress(total: missing.length, done: 0, failed: 0),
    );
    await runDownloads<int>(
      missing,
      _fonts.downloadPage,
      concurrency: 4,
      isCancelled: () => _cancelFonts || !ref.mounted,
      onProgress: (p) {
        if (ref.mounted) state = state.copyWith(fontsProgress: () => p);
      },
    );
    if (!ref.mounted) return;
    await refresh();
    if (!ref.mounted) return;
    state = state.copyWith(fontsProgress: () => null);
  }

  void cancelFonts() => _cancelFonts = true;

  Future<void> deleteFonts() async {
    await _fonts.deleteAll();
    await refresh();
  }

  // ---- Audio, one sourate at a time, for the preferred reciter

  Reciter get _reciter =>
      reciterById(ref.read(audioSettingsProvider).reciterId);

  Future<({int first, int count})> _surahRange(int surah) async {
    final text = await ref.read(quranTextProvider.future);
    final reference = await ref.read(quranReferenceProvider.future);
    return (
      first: text.globalAyahNumber(surah, 1),
      count: reference.surahByNumber(surah).numberOfAyahs,
    );
  }

  /// How many verses of [surah] are cached for the preferred reciter.
  int cachedVerses(int surah, {required int first, required int count}) =>
      cachedAyahCount(
        cachedFileNames: state.cachedAudio,
        reciter: _reciter,
        firstGlobal: first,
        ayahCount: count,
      );

  Future<void> downloadSurah(int surah) async {
    if (state.audioRunning) return;
    _cancelAudio = false;
    final range = await _surahRange(surah);
    final reciter = _reciter;
    final urls = [
      for (var i = 0; i < range.count; i++)
        ayahAudioUrl(reciter, range.first + i),
    ];
    state = state.copyWith(
      audioSurah: () => surah,
      audioProgress: () =>
          DownloadProgress(total: urls.length, done: 0, failed: 0),
    );
    await runDownloads<String>(
      urls,
      _audio.download,
      concurrency: 3,
      isCancelled: () => _cancelAudio || !ref.mounted,
      onProgress: (p) {
        if (ref.mounted) state = state.copyWith(audioProgress: () => p);
      },
    );
    if (!ref.mounted) return;
    await refresh();
    if (!ref.mounted) return;
    state = state.copyWith(audioSurah: () => null, audioProgress: () => null);
  }

  void cancelAudio() => _cancelAudio = true;

  Future<void> deleteSurah(int surah) async {
    final range = await _surahRange(surah);
    await _audio.delete(
      surahFileNames(
        reciter: _reciter,
        firstGlobal: range.first,
        ayahCount: range.count,
      ),
    );
    await refresh();
  }

  Future<void> deleteAllAudio() async {
    await _audio.deleteAll();
    await refresh();
  }
}

final offlineControllerProvider =
    NotifierProvider<OfflineController, OfflineState>(OfflineController.new);
