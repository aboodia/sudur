import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/reciter.dart';
import '../../core/mushaf/mushaf_font_cache.dart';
import '../../core/offline/offline_controller.dart';
import '../../core/offline/offline_status.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/quran_text/quran_text_repository.dart';
import '../../core/settings/audio_settings.dart';
import '../../l10n/app_localizations.dart';

/// Contenus hors-ligne: what can be downloaded to work without a
/// connection (the Mushaf's pages and the recitation audio), how much room
/// it takes, and how to free it.
class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(offlineControllerProvider);
    final reciter = reciterById(ref.watch(audioSettingsProvider).reciterId);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final textAsync = ref.watch(quranTextProvider);

    final reference = referenceAsync.value;
    final text = textAsync.value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offlineTitle)),
      body: SafeArea(
        child: !state.loaded || reference == null || text == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          l10n.offlineIntro,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.offlineStorage(formatBytes(state.totalBytes)),
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 20),
                        _MushafSection(state: state),
                        const SizedBox(height: 28),
                        Text(
                          l10n.offlineAudioTitle(reciter.name),
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.offlineAudioHint,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (state.cachedAudio.isNotEmpty)
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: () => _confirmThen(
                                context,
                                ref
                                    .read(offlineControllerProvider.notifier)
                                    .deleteAllAudio,
                              ),
                              child: Text(l10n.offlineAudioDeleteAll),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SliverList.builder(
                    itemCount: reference.surahs.length,
                    itemBuilder: (context, index) {
                      final surah = reference.surahs[index];
                      return _SurahRow(
                        number: surah.number,
                        name: surah.englishName,
                        total: surah.numberOfAyahs,
                        first: text.globalAyahNumber(surah.number, 1),
                        reciter: reciter,
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }
}

Future<void> _confirmThen(
  BuildContext context,
  Future<void> Function() action,
) async {
  final l10n = AppLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.offlineConfirmTitle),
      content: Text(l10n.offlineConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.offlineConfirmNo),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.offlineConfirmYes),
        ),
      ],
    ),
  );
  if (ok == true) await action();
}

class _MushafSection extends ConsumerWidget {
  const _MushafSection({required this.state});

  final OfflineState state;

  String _sizeWarning(AppLocalizations l10n) {
    final remaining = estimateRemainingFontBytes(
      cachedPages: state.cachedPages.length,
      fontBytes: state.fontBytes,
      totalPages: MushafFontCache.pageCount,
    );
    return remaining == null
        ? l10n.offlineMushafWifi
        : l10n.offlineMushafEstimate(formatBytes(remaining));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = ref.read(offlineControllerProvider.notifier);
    final progress = state.fontsProgress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.offlineMushafTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            l10n.offlineMushafCount(state.cachedPages.length),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress != null
                  ? progress.fraction
                  : state.cachedPages.length / MushafFontCache.pageCount,
              minHeight: 8,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 6),
            Text(
              l10n.offlineProgress(progress.finished, progress.total),
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (progress != null && progress.failed > 0) ...[
            const SizedBox(height: 6),
            Text(
              l10n.offlineFailed(progress.failed),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          if (!state.fontsRunning && !state.fontsComplete) ...[
            const SizedBox(height: 8),
            Text(_sizeWarning(l10n), style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              if (state.fontsRunning)
                OutlinedButton(
                  onPressed: controller.cancelFonts,
                  child: Text(l10n.offlineMushafStop),
                )
              else if (!state.fontsComplete)
                FilledButton.icon(
                  onPressed: controller.downloadAllFonts,
                  icon: const Icon(Icons.download),
                  label: Text(l10n.offlineMushafDownload),
                ),
              if (!state.fontsRunning && state.cachedPages.isNotEmpty)
                TextButton(
                  onPressed: () =>
                      _confirmThen(context, controller.deleteFonts),
                  child: Text(l10n.offlineMushafDelete),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SurahRow extends ConsumerWidget {
  const _SurahRow({
    required this.number,
    required this.name,
    required this.total,
    required this.first,
    required this.reciter,
  });

  final int number;
  final String name;
  final int total;
  final int first;
  final Reciter reciter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(offlineControllerProvider);
    final controller = ref.read(offlineControllerProvider.notifier);

    final cached = cachedAyahCount(
      cachedFileNames: state.cachedAudio,
      reciter: reciter,
      firstGlobal: first,
      ayahCount: total,
    );
    final downloading = state.audioSurah == number;
    final complete = cached >= total;

    Widget trailing;
    if (downloading) {
      trailing = IconButton(
        tooltip: l10n.offlineMushafStop,
        onPressed: controller.cancelAudio,
        icon: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                value: state.audioProgress?.fraction,
                strokeWidth: 3,
              ),
            ),
            const Icon(Icons.stop, size: 14),
          ],
        ),
      );
    } else if (complete) {
      trailing = IconButton(
        tooltip: l10n.offlineSurahDelete,
        onPressed: () => controller.deleteSurah(number),
        icon: Icon(Icons.delete_outline, color: theme.colorScheme.outline),
      );
    } else {
      trailing = IconButton(
        tooltip: l10n.offlineSurahDownload,
        // One download at a time: the others wait for it to finish.
        onPressed: state.audioRunning
            ? null
            : () => controller.downloadSurah(number),
        icon: const Icon(Icons.download_outlined),
      );
    }

    return ListTile(
      leading: complete
          ? Icon(Icons.download_done, color: theme.colorScheme.primary)
          : const Icon(Icons.cloud_outlined),
      title: Text('$number. $name'),
      subtitle: Text(l10n.offlineSurahVerses(cached, total)),
      trailing: trailing,
    );
  }
}
