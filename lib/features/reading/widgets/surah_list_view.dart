import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/database/memorization_repository.dart';
import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/mushaf/surah_name_glyph.dart';
import '../../../core/quran_reference/quran_reference_models.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/quran_reference/surah_search.dart';
import '../../../core/settings/last_read.dart';

class SurahListView extends ConsumerStatefulWidget {
  const SurahListView({super.key, required this.onSurahSelected});

  final void Function(int surahNumber, {int? startAyah}) onSurahSelected;

  @override
  ConsumerState<SurahListView> createState() => _SurahListViewState();
}

class _SurahListViewState extends ConsumerState<SurahListView> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);
    final theme = Theme.of(context);
    final memorized = {
      for (final r in ref.watch(surahProgressProvider).value ?? const [])
        if (r.completedAt != null) r.surahNumber,
    };

    return referenceAsync.when(
      data: (reference) {
        final surahs = [
          for (final s in reference.surahs)
            if (surahMatches(s, _query)) s,
        ];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Chercher une sourate (nom ou numéro)',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Effacer',
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _query = ''),
                        ),
                ),
              ),
            ),
            if (_query.isEmpty) const _ResumeCard(),
            Expanded(
              child: surahs.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune sourate ne correspond.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: surahs.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final surah = surahs[index];
                        final isPlayingThis =
                            playback.surahNumber == surah.number;

                        return ListTile(
                          tileColor: isPlayingThis
                              ? theme.colorScheme.primaryContainer.withValues(
                                  alpha: 0.3,
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            radius: 18,
                            child: Text(
                              '${surah.number}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  surah.englishName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (memorized.contains(surah.number)) ...[
                                const SizedBox(width: 6),
                                Tooltip(
                                  message: 'Mémorisée',
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              const SizedBox(width: 8),
                              // Bannière décorative du nom en arabe, rendue
                              // via le jeu de ligatures QUL "surah-name-v4"
                              // (§6.6) plutôt qu'un simple texte Unicode brut
                              // — cohérent avec le style Mushaf utilisé
                              // ailleurs dans l'app.
                              Text(
                                surahNameLigature(surah.number),
                                style: TextStyle(
                                  fontFamily: 'SurahNameV4',
                                  fontSize: 24,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '${surah.frenchNameTranslation} · ${surah.numberOfAyahs} versets · '
                            '${surah.revelationType == RevelationType.meccan ? 'Mecquoise' : 'Médinoise'}',
                          ),
                          // Marque la sourate en cours de lecture —
                          // mini-indicateur plutôt qu'un lecteur permanent sur
                          // tous les écrans : cliquer dessus ramène à l'écran
                          // de lecture, où se trouve le vrai lecteur.
                          trailing: isPlayingThis
                              ? Tooltip(
                                  message: playback.isPlaying
                                      ? 'En cours de lecture'
                                      : 'En pause',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        playback.isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        Icons.graphic_eq,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                          onTap: () => widget.onSurahSelected(
                            surah.number,
                            startAyah: isPlayingThis
                                ? playback.ayahNumber
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur : $err')),
    );
  }
}

/// "Reprendre ta lecture": back to the Mushaf page last read.
class _ResumeCard extends ConsumerWidget {
  const _ResumeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(lastReadProvider);
    final mushaf = ref.watch(mushafRepositoryProvider).value;
    final reference = ref.watch(quranReferenceProvider).value;
    if (page == null || mushaf == null || reference == null) {
      return const SizedBox.shrink();
    }
    final first = mushaf.firstAyahOnPage(page);
    if (first == null) return const SizedBox.shrink();
    final name = reference.surahByNumber(first.surah).englishName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: const Icon(Icons.bookmark_outline),
          title: const Text('Reprendre ta lecture'),
          subtitle: Text('$name · page $page'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/lecture/mushaf?page=$page'),
        ),
      ),
    );
  }
}
