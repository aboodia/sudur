import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/database/app_database.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../session_controller.dart';
import '../widgets/session_step_scaffold.dart';

/// Étape 5 : récitation du passage entier d'un seul tenant, avec le statut
/// de chaque verset (validé / hésitation / en cours / à venir) visible en
/// un coup d'œil — c'est ce qui "fixe" le passage, au-delà des versets pris
/// isolément dans les étapes précédentes.
class ChainScreen extends ConsumerWidget {
  const ChainScreen({super.key, required this.passage});

  final Passage passage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final session = ref.watch(guidedSessionProvider);
    final controller = ref.read(guidedSessionProvider.notifier);
    final surahName =
        referenceAsync.value?.surahByNumber(passage.surahNumber).englishName ??
        '';

    return SessionStepScaffold(
      stepIndex: stepChain,
      stepLabel: 'Enchaîner',
      headerLabel:
          '${surahName.toUpperCase()} · ${passage.ayahStart}-${passage.ayahEnd}',
      onQuit: () => Navigator.of(context).maybePop(),
      onBack: () => controller.goToPreviousStep(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.chainTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.chainSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: passage.ayahEnd - passage.ayahStart + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final ayah = passage.ayahStart + index;
                  final status =
                      session.chainStatuses[ayah] ?? ChainAyahStatus.upcoming;
                  return _ChainAyahTile(
                    ayah: ayah,
                    status: status,
                    label: l10n.chainVerseLabel(ayah),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Icon(Icons.mic_none, size: 40),
            const SizedBox(height: 4),
            const Text('Récitation continue', textAlign: TextAlign.center),
            const SizedBox(height: 12),
          ],
        ),
      ),
      bottomBar: FilledButton(
        onPressed: () async {
          await ref.read(audioPlaybackProvider.notifier).stop();
          await controller.finishPassage();
        },
        child: Text(l10n.finishPassageButton),
      ),
    );
  }
}

class _ChainAyahTile extends StatelessWidget {
  const _ChainAyahTile({
    required this.ayah,
    required this.status,
    required this.label,
  });

  final int ayah;
  final ChainAyahStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isCurrent = status == ChainAyahStatus.current;
    final isUpcoming = status == ChainAyahStatus.upcoming;

    final Widget leading;
    final Color borderColor;
    switch (status) {
      case ChainAyahStatus.validated:
        leading = CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Icon(
            Icons.check,
            color: theme.colorScheme.onPrimary,
            size: 18,
          ),
        );
        borderColor = theme.colorScheme.outlineVariant;
      case ChainAyahStatus.hesitant:
        leading = CircleAvatar(
          backgroundColor: theme.colorScheme.tertiary,
          child: Icon(
            Icons.check,
            color: theme.colorScheme.onTertiary,
            size: 18,
          ),
        );
        borderColor = theme.colorScheme.outlineVariant;
      case ChainAyahStatus.current:
        leading = CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            '$ayah',
            style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
          ),
        );
        borderColor = theme.colorScheme.primary;
      case ChainAyahStatus.upcoming:
        leading = CircleAvatar(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Text('$ayah', style: theme.textTheme.bodyMedium),
        );
        borderColor = theme.colorScheme.outlineVariant;
    }

    final trailingText = switch (status) {
      ChainAyahStatus.validated => l10n.chainStatusValidated,
      ChainAyahStatus.hesitant => l10n.chainStatusHesitant,
      ChainAyahStatus.current => l10n.chainStatusCurrent,
      ChainAyahStatus.upcoming => '',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: isCurrent ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isUpcoming ? theme.colorScheme.outline : null,
              ),
            ),
          ),
          Text(
            trailingText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: status == ChainAyahStatus.hesitant
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
