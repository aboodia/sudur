import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/bookmark_repository.dart';
import '../../../core/database/profile_repository.dart';
import '../../../core/quran_text/quran_text_models.dart';
import '../../../core/quran_text/sajda_repository.dart';
import '../../../core/settings/reading_settings.dart';
import '../../../l10n/app_localizations.dart';

class AyahCard extends ConsumerWidget {
  const AyahCard({
    super.key,
    required this.surahNumber,
    required this.ayah,
    required this.isPlaying,
    required this.onTap,
    this.basmalah,
  });

  final int surahNumber;
  final AyahText ayah;
  final bool isPlaying;
  final VoidCallback onTap;

  /// Set on ayah 1 of every sourate that has a basmalah (all but
  /// Al-Fatiha and At-Tawbah) — shown as its own heading, distinct from
  /// the ayah's own text, instead of running the two together.
  final String? basmalah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readingSettingsProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final theme = Theme.of(context);

    return Container(
      color: isPlaying ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35) : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (basmalah case final basmalah?) ...[
            Text(
              basmalah,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 22 * settings.textScale,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                child: Text('${ayah.numberInSurah}', style: const TextStyle(fontSize: 12)),
              ),
              _SajdaBadge(surahNumber: surahNumber, ayahNumber: ayah.numberInSurah),
              const Spacer(),
              if (profileAsync.value case final profile?)
                _BookmarkButton(
                  profileId: profile.id,
                  surahNumber: surahNumber,
                  ayahNumber: ayah.numberInSurah,
                ),
              IconButton(
                tooltip: isPlaying
                    ? AppLocalizations.of(context).tooltipPause
                    : AppLocalizations.of(context).tooltipPlay,
                icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle_outline),
                onPressed: onTap,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            ayah.arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 26 * settings.textScale,
              height: 1.9,
            ),
          ),
          if (settings.displayMode == ReadingDisplayMode.transliteration) ...[
            const SizedBox(height: 8),
            Text(
              ayah.transliteration,
              style: TextStyle(
                fontSize: 15 * settings.textScale,
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (settings.displayMode == ReadingDisplayMode.bilingual) ...[
            const SizedBox(height: 8),
            Text(
              ayah.french,
              style: TextStyle(
                fontSize: 15 * settings.textScale,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SajdaBadge extends ConsumerWidget {
  const _SajdaBadge({required this.surahNumber, required this.ayahNumber});

  final int surahNumber;
  final int ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sajdaType = ref.watch(sajdaRepositoryProvider).value?.sajdaTypeFor(surahNumber, ayahNumber);
    if (sajdaType == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: sajdaType == 'required' ? 'Sajda obligatoire' : 'Sajda recommandée',
        child: Chip(
          label: const Text('۩', style: TextStyle(fontFamily: 'AmiriQuran')),
          labelPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: sajdaType == 'required'
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}

class _BookmarkButton extends ConsumerWidget {
  const _BookmarkButton({
    required this.profileId,
    required this.surahNumber,
    required this.ayahNumber,
  });

  final String profileId;
  final int surahNumber;
  final int ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksProvider).value ?? const [];
    final isBookmarked = bookmarks.any(
      (b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber,
    );
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: isBookmarked ? l10n.tooltipBookmarkRemove : l10n.tooltipBookmarkAdd,
      icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () => ref
          .read(bookmarkRepositoryProvider)
          .toggle(profileId, surahNumber, ayahNumber),
    );
  }
}
