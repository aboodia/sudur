import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/database/memorization_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Écran de fin sobre (fond Nuit bleue, pas de confettis) : bilan du
/// passage, aperçu du cycle de révision à venir (J+1/J+3/J+7/J+30) et
/// progression de la sourate.
class CompletedScreen extends ConsumerWidget {
  const CompletedScreen({
    super.key,
    required this.surahNumber,
    required this.ayahStart,
    required this.ayahEnd,
    required this.startedAt,
    required this.watchedAyahCount,
  });

  final int surahNumber;
  final int ayahStart;
  final int ayahEnd;
  final DateTime startedAt;
  final int watchedAyahCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final surahProgressAsync = ref.watch(surahProgressProvider);
    final surahName =
        referenceAsync.value?.surahByNumber(surahNumber).englishName ??
        'Sourate $surahNumber';
    final verseCount = ayahEnd - ayahStart + 1;
    final practiceMinutes = DateTime.now()
        .difference(startedAt)
        .inMinutes
        .clamp(1, 999);

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          brightness: Brightness.dark,
          surface: const Color(0xFF101A2C),
          onSurface: const Color(0xFFF4EFE7),
        ),
        scaffoldBackgroundColor: const Color(0xFF101A2C),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF101A2C),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF24427C),
                      ),
                      child: const Icon(Icons.water_drop, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.passageMemorizedBadge,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFFB57A64),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ayahStart == ayahEnd
                      ? l10n.passageMemorizedTitleSingle(surahName, ayahStart)
                      : l10n.passageMemorizedTitle(
                          surahName,
                          ayahStart,
                          ayahEnd,
                        ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.barakAllahuFik,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 22,
                    color: Color(0xFFB57A64),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.passageMemorizedSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(label: l10n.statVerses(verseCount)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatTile(
                        label: l10n.statDuration(practiceMinutes),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatTile(
                        label: l10n.statToWatch(watchedAyahCount),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.reviewCycleTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ReviewCyclePoint(
                            label: l10n.reviewCycleTomorrow,
                            filled: true,
                          ),
                          _ReviewCyclePoint(label: 'J+3', filled: false),
                          _ReviewCyclePoint(label: 'J+7', filled: false),
                          _ReviewCyclePoint(label: 'J+30', filled: false),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                surahProgressAsync.when(
                  data: (rows) {
                    final row = rows
                        .where((r) => r.surahNumber == surahNumber)
                        .toList();
                    if (row.isEmpty) return const SizedBox.shrink();
                    final entry = row.first;
                    final complete = entry.completedAt != null;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.surahProgressLabel(surahName),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                l10n.surahProgressCount(
                                  entry.memorizedAyahCount,
                                  entry.totalAyahCount,
                                ),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value:
                                  entry.memorizedAyahCount /
                                  entry.totalAyahCount,
                              minHeight: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFFB57A64),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            complete
                                ? l10n.surahAlreadyComplete
                                : l10n.surahProgressRemaining(
                                    entry.totalAyahCount -
                                        entry.memorizedAyahCount,
                                  ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF4EFE7),
                      foregroundColor: const Color(0xFF101A2C),
                    ),
                    onPressed: () => context.go('/accueil'),
                    child: Text(l10n.backToHome),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    final audio = ref.read(audioPlaybackProvider.notifier);
                    audio.setRepeatRange(ayahStart, ayahEnd);
                    audio.playFrom(surahNumber, ayahStart);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  child: Text(l10n.replayPassage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ReviewCyclePoint extends StatelessWidget {
  const _ReviewCyclePoint({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? const Color(0xFFB57A64) : Colors.transparent,
            border: Border.all(
              color: filled ? const Color(0xFFB57A64) : Colors.white38,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
