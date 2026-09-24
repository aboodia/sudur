import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/quran_reference/quran_reference_repository.dart';

class JuzListView extends ConsumerWidget {
  const JuzListView({super.key, required this.onSurahSelected});

  final void Function(int surahNumber, {int? startAyah}) onSurahSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    return referenceAsync.when(
      data: (reference) => ListView.separated(
        itemCount: reference.juzStarts.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final boundary = reference.juzStarts[index];
          final startSurah = reference.surahByNumber(boundary.surah);
          return ListTile(
            leading: CircleAvatar(child: Text('${boundary.juz}')),
            title: Text('Juz ${boundary.juz}'),
            subtitle: Text('À partir de ${startSurah.englishName}, verset ${boundary.ayah}'),
            onTap: () => onSurahSelected(boundary.surah, startAyah: boundary.ayah),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur : $err')),
    );
  }
}
