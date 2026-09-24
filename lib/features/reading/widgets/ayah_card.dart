import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/bookmark_repository.dart';
import '../../../core/database/profile_repository.dart';
import '../../../core/quran_text/quran_text_models.dart';
import '../../../core/settings/reading_settings.dart';

class AyahCard extends ConsumerWidget {
  const AyahCard({
    super.key,
    required this.surahNumber,
    required this.ayah,
    required this.isPlaying,
    required this.onTap,
  });

  final int surahNumber;
  final AyahText ayah;
  final bool isPlaying;
  final VoidCallback onTap;

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
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                child: Text('${ayah.numberInSurah}', style: const TextStyle(fontSize: 12)),
              ),
              const Spacer(),
              if (profileAsync.value case final profile?)
                _BookmarkButton(
                  profileId: profile.id,
                  surahNumber: surahNumber,
                  ayahNumber: ayah.numberInSurah,
                ),
              IconButton(
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
    return IconButton(
      icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
      onPressed: () => ref
          .read(bookmarkRepositoryProvider)
          .toggle(profileId, surahNumber, ayahNumber),
    );
  }
}
