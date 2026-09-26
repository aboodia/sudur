import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/quran_reference/quran_reference_repository.dart';
import '../onboarding_draft.dart';

/// Sourates entières uniquement pour cette v1 de l'Onboarding — pas de
/// sélection par Juz (demanderait de calculer des plages de versets
/// partielles par sourate).
class MemorizedSurahsStep extends ConsumerWidget {
  const MemorizedSurahsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    final draft = ref.watch(onboardingDraftProvider);
    final controller = ref.read(onboardingDraftProvider.notifier);

    return referenceAsync.when(
      data: (reference) {
        final allNumbers = reference.surahs.map((s) => s.number);
        final allSelected = draft.memorizedSurahs.length == reference.surahs.length;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quelles sourates avez-vous déjà mémorisées ?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aucune ? Pas de souci, laissez tout décoché.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: allSelected
                    ? controller.deselectAllSurahs
                    : () => controller.selectAllSurahs(allNumbers),
                child: Text(allSelected ? 'Tout désélectionner' : 'Tout sélectionner'),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: reference.surahs.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final surah = reference.surahs[index];
                  final checked = draft.memorizedSurahs.contains(surah.number);
                  return CheckboxListTile(
                    value: checked,
                    onChanged: (_) => controller.toggleSurah(surah.number),
                    title: Text('${surah.englishName} — ${surah.frenchNameTranslation}'),
                    subtitle: Text('${surah.numberOfAyahs} versets'),
                    secondary: CircleAvatar(child: Text('${surah.number}')),
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
