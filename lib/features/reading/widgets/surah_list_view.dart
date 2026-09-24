import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/quran_reference/quran_reference_models.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';

class SurahListView extends ConsumerWidget {
  const SurahListView({super.key, required this.onSurahSelected});

  final void Function(int surahNumber, {int? startAyah}) onSurahSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    return referenceAsync.when(
      data: (reference) => ListView.separated(
        itemCount: reference.surahs.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final surah = reference.surahs[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${surah.number}')),
            title: Text('${surah.englishName} — ${surah.nameArabic}'),
            subtitle: Text(
              '${surah.englishNameTranslation} · ${surah.numberOfAyahs} versets · '
              '${surah.revelationType == RevelationType.meccan ? 'Mecquoise' : 'Médinoise'}',
            ),
            onTap: () => onSurahSelected(surah.number),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur : $err')),
    );
  }
}
