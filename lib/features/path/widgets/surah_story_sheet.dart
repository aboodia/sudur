import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/path/surah_stories.dart';
import '../../../l10n/app_localizations.dart';

/// "Histoire débloquée" — the story unlocked by completing a sourate.
Future<void> showSurahStorySheet(
  BuildContext context, {
  required int surahNumber,
  required String surahName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: SurahStoryContent(
          surahNumber: surahNumber,
          surahName: surahName,
        ),
      ),
    ),
  );
}

/// The story itself, or a plain note while no validated story exists for
/// that sourate — never made-up content.
class SurahStoryContent extends ConsumerWidget {
  const SurahStoryContent({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  final int surahNumber;
  final String surahName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final story = ref.watch(surahStoriesProvider).value?[surahNumber];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.storyUnlockedTitle.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.tertiary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(story?.title ?? surahName, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (story != null) ...[
          Text(story.body, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          Text(
            l10n.storySource(story.source),
            style: theme.textTheme.bodySmall,
          ),
        ] else
          Text(l10n.storyComingSoon, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
