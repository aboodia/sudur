import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/quran_reference/quran_reference_models.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';

class SurahListView extends ConsumerWidget {
  const SurahListView({super.key, required this.onSurahSelected});

  final void Function(int surahNumber, {int? startAyah}) onSurahSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);
    final theme = Theme.of(context);

    return referenceAsync.when(
      data: (reference) => ListView.separated(
        itemCount: reference.surahs.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final surah = reference.surahs[index];
          final isPlayingThis = playback.surahNumber == surah.number;

          return ListTile(
            tileColor: isPlayingThis ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
            leading: CircleAvatar(child: Text('${surah.number}')),
            title: Text('${surah.englishName} — ${surah.nameArabic}'),
            subtitle: Text(
              '${surah.englishNameTranslation} · ${surah.numberOfAyahs} versets · '
              '${surah.revelationType == RevelationType.meccan ? 'Mecquoise' : 'Médinoise'}',
            ),
            // Marque la sourate en cours de lecture — mini-indicateur plutôt
            // qu'un lecteur permanent sur tous les écrans : cliquer dessus
            // ramène à l'écran de lecture, où se trouve le vrai lecteur.
            trailing: isPlayingThis
                ? Tooltip(
                    message: playback.isPlaying ? 'En cours de lecture' : 'En pause',
                    child: Icon(
                      playback.isPlaying ? Icons.play_circle_fill : Icons.pause_circle_filled,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : null,
            onTap: () => onSurahSelected(
              surah.number,
              startAyah: isPlayingThis ? playback.ayahNumber : null,
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur : $err')),
    );
  }
}
