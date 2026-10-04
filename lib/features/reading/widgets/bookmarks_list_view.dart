import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/bookmark_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';

class BookmarksListView extends ConsumerWidget {
  const BookmarksListView({super.key, required this.onSurahSelected});

  final void Function(int surahNumber, {int? startAyah}) onSurahSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);

    return bookmarksAsync.when(
      data: (bookmarks) {
        if (bookmarks.isEmpty) {
          final theme = Theme.of(context);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 40,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucun signet pour le moment',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dans la vue texte d\'une sourate, touche l\'icône de signet '
                    'd\'un verset : tu le retrouveras ici.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }
        final reference = referenceAsync.value;
        return ListView.separated(
          itemCount: bookmarks.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final bookmark = bookmarks[index];
            final surahName = reference?.surahByNumber(bookmark.surahNumber).englishName ??
                'Sourate ${bookmark.surahNumber}';
            return ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text('$surahName, verset ${bookmark.ayahNumber}'),
              onTap: () => onSurahSelected(bookmark.surahNumber, startAyah: bookmark.ayahNumber),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur : $err')),
    );
  }
}
