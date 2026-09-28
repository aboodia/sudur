import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/memorization/review_scheduler.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/quran_text/quran_text_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../session_controller.dart';
import '../widgets/record_control.dart';
import '../widgets/session_step_scaffold.dart';

/// Étape 4 : récitation sans aide (seul le premier mot reste visible),
/// vérification optionnelle du texte, puis auto-évaluation à 3 niveaux.
class ReciteScreen extends ConsumerStatefulWidget {
  const ReciteScreen({
    super.key,
    required this.passage,
    required this.ayahNumber,
  });

  final Passage passage;
  final int ayahNumber;

  @override
  ConsumerState<ReciteScreen> createState() => _ReciteScreenState();
}

class _ReciteScreenState extends ConsumerState<ReciteScreen> {
  bool _verseVisible = false;
  ReciteOutcome? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textAsync = ref.watch(quranTextProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final controller = ref.read(guidedSessionProvider.notifier);
    final theme = Theme.of(context);
    final surahName =
        referenceAsync.value
            ?.surahByNumber(widget.passage.surahNumber)
            .englishName ??
        '';

    return SessionStepScaffold(
      stepIndex: stepRecite,
      stepLabel: 'Réciter',
      headerLabel:
          '${surahName.toUpperCase()} · ${widget.passage.ayahStart}-${widget.passage.ayahEnd}',
      onQuit: () => Navigator.of(context).maybePop(),
      onBack: () => controller.goToPreviousStep(),
      body: textAsync.when(
        data: (repo) {
          final ayah = repo
              .surah(widget.passage.surahNumber)
              .ayahs[widget.ayahNumber - 1];
          final words = ayah.arabic.split(RegExp(r'\s+'));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.reciteVerseNoHelp(widget.ayahNumber),
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.reciteInstructions,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _verseVisible
                          ? words.join(' ')
                          : (words.isEmpty ? '' : '${words.first} …'),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 30,
                        height: 1.9,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          setState(() => _verseVisible = !_verseVisible),
                      child: Text(
                        _verseVisible ? l10n.hideVerse : l10n.showVerse,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const RecordControl(),
                  ],
                ),
                const SizedBox(height: 20),
                Text(l10n.howWasRecitation, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                _OutcomeTile(
                  title: l10n.outcomeClean,
                  subtitle: l10n.outcomeCleanSub,
                  selected: _selected == ReciteOutcome.clean,
                  onTap: () => setState(() => _selected = ReciteOutcome.clean),
                ),
                _OutcomeTile(
                  title: l10n.outcomeHesitant,
                  subtitle: l10n.outcomeHesitantSub,
                  selected: _selected == ReciteOutcome.hesitant,
                  onTap: () =>
                      setState(() => _selected = ReciteOutcome.hesitant),
                ),
                _OutcomeTile(
                  title: l10n.outcomeRedo,
                  subtitle: l10n.outcomeRedoSub,
                  selected: _selected == ReciteOutcome.redo,
                  onTap: () => setState(() => _selected = ReciteOutcome.redo),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
      bottomBar: FilledButton(
        onPressed: _selected == null
            ? null
            : () => controller.submitReciteOutcome(_selected!),
        child: Text(l10n.continueLabel),
      ),
    );
  }
}

class _OutcomeTile extends StatelessWidget {
  const _OutcomeTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                : null,
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
