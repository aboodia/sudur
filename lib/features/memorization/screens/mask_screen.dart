import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/memorization/masking_strategy.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/quran_text/quran_text_repository.dart';
import '../../../core/quran_text/quran_words.dart';
import '../../../l10n/app_localizations.dart';
import '../session_controller.dart';
import '../widgets/ayah_text_view.dart';
import '../widgets/session_step_scaffold.dart';

/// Étape 3 : masquage progressif, un verset à la fois — le niveau (Léger /
/// Moyen / Complet) est un choix libre de l'utilisateur, pas une
/// progression forcée ; taper un mot masqué le révèle et le marque
/// "fragile" pour la révision.
class MaskScreen extends ConsumerWidget {
  const MaskScreen({
    super.key,
    required this.passage,
    required this.ayahNumber,
  });

  final Passage passage;
  final int ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textAsync = ref.watch(quranTextProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final session = ref.watch(guidedSessionProvider);
    final controller = ref.read(guidedSessionProvider.notifier);
    final theme = Theme.of(context);
    final surahName =
        referenceAsync.value?.surahByNumber(passage.surahNumber).englishName ??
        '';

    return SessionStepScaffold(
      stepIndex: stepMask,
      stepLabel: 'Masquer',
      headerLabel:
          '${surahName.toUpperCase()} · ${passage.ayahStart}-${passage.ayahEnd}',
      onQuit: () => Navigator.of(context).maybePop(),
      onBack: session.isRedoFlow ? null : () => controller.goToPreviousStep(),
      body: textAsync.when(
        data: (repo) {
          final ayah = repo.surah(passage.surahNumber).ayahs[ayahNumber - 1];
          final words = quranWords(ayah.arabic);
          final seed = passage.surahNumber * 1000 + ayahNumber;
          final hidden = maskedIndices(words, session.maskLevel, seed).toSet();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.verseOfTotal(
                    ayahNumber - passage.ayahStart + 1,
                    passage.ayahEnd - passage.ayahStart + 1,
                  ),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(l10n.maskInstructions, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                SegmentedButton<MaskLevel>(
                  segments: [
                    ButtonSegment(
                      value: MaskLevel.light,
                      label: Text(l10n.levelLight),
                    ),
                    ButtonSegment(
                      value: MaskLevel.medium,
                      label: Text(l10n.levelMedium),
                    ),
                    ButtonSegment(
                      value: MaskLevel.full,
                      label: Text(l10n.levelFull),
                    ),
                  ],
                  selected: {session.maskLevel},
                  onSelectionChanged: (selection) =>
                      controller.setMaskLevel(selection.first),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: AyahTextView(
                          words: words,
                          hiddenIndices: hidden,
                          revealedIndices: session.revealedIndices,
                          onWordTap: controller.revealWord,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        session.revealedIndices.isEmpty
                            ? l10n.noWordRevealedYet
                            : l10n.someWordsRevealed(
                                session.revealedIndices.length,
                              ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
      bottomBar: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.setMaskLevel(session.maskLevel),
              child: Text(l10n.restartStep),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: controller.finishMaskingCurrentAyah,
              child: Text(l10n.iKnowIt),
            ),
          ),
        ],
      ),
    );
  }
}
