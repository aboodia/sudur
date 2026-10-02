import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/memorization_repository.dart';
import '../../../core/format/french_date.dart';
import '../../../core/memorization/review_scheduler.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/quran_text/quran_text_repository.dart';
import '../../../core/quran_text/quran_words.dart';
import '../../../l10n/app_localizations.dart';
import '../../memorization/widgets/outcome_tile.dart';
import '../../memorization/widgets/record_control.dart';
import '../revision_session_controller.dart';

/// One revision session: the verses due today, one at a time — recite from
/// the first word, check, rate yourself — then a short, encouraging recap.
class RevisionSessionScreen extends ConsumerStatefulWidget {
  const RevisionSessionScreen({super.key});

  @override
  ConsumerState<RevisionSessionScreen> createState() =>
      _RevisionSessionScreenState();
}

class _RevisionSessionScreenState extends ConsumerState<RevisionSessionScreen> {
  @override
  void initState() {
    super.initState();
    // Deferred, like the other screens: writing provider state while the
    // widget tree is still building is rejected by Riverpod.
    Future.microtask(() {
      if (mounted) ref.read(revisionSessionProvider.notifier).start();
    });
  }

  void _leave() {
    // Reviews already rated are saved one by one; refresh what depends on them.
    ref.invalidate(dueReviewsProvider);
    ref.invalidate(ayahProgressProvider);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/accueil');
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(revisionSessionProvider);

    final Widget body;
    if (!session.isLoaded) {
      body = const Center(child: CircularProgressIndicator());
    } else if (session.isEmpty) {
      body = _EmptyView(onBack: _leave);
    } else if (session.isFinished) {
      body = _SummaryView(session: session, onBack: _leave);
    } else {
      body = _QuestionView(
        key: ValueKey(session.index),
        session: session,
        onQuit: _leave,
      );
    }

    return Scaffold(body: SafeArea(child: body));
  }
}

class _QuestionView extends ConsumerStatefulWidget {
  const _QuestionView({super.key, required this.session, required this.onQuit});

  final RevisionSessionState session;
  final VoidCallback onQuit;

  @override
  ConsumerState<_QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends ConsumerState<_QuestionView> {
  bool _verseVisible = false;
  ReciteOutcome? _selected;
  bool _submitting = false;

  Future<void> _continue() async {
    final outcome = _selected;
    if (outcome == null || _submitting) return;
    setState(() => _submitting = true);
    await ref.read(revisionSessionProvider.notifier).submit(outcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = widget.session;
    final entry = session.current!;
    final textAsync = ref.watch(quranTextProvider);
    final surahName =
        ref
            .watch(quranReferenceProvider)
            .value
            ?.surahByNumber(entry.surahNumber)
            .englishName ??
        '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.revisionQuitTooltip,
                onPressed: widget.onQuit,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      surahName.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      l10n.verseOfTotal(
                        session.index + 1,
                        session.items.length,
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48, height: 48),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: session.index / session.items.length,
              minHeight: 4,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.revisionPassageSingle(surahName, entry.ayahNumber),
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(l10n.reciteInstructions, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              textAsync.when(
                data: (repo) {
                  final ayah = repo
                      .surah(entry.surahNumber)
                      .ayahs[entry.ayahNumber - 1];
                  final words = quranWords(ayah.arabic);
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
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
                        if (_verseVisible) ...[
                          const SizedBox(height: 12),
                          Text(
                            ayah.french,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Center(child: Text('Erreur : $err')),
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
              OutcomeTile(
                title: l10n.outcomeClean,
                subtitle: l10n.outcomeCleanSub,
                selected: _selected == ReciteOutcome.clean,
                onTap: () => setState(() => _selected = ReciteOutcome.clean),
              ),
              OutcomeTile(
                title: l10n.outcomeHesitant,
                subtitle: l10n.outcomeHesitantSub,
                selected: _selected == ReciteOutcome.hesitant,
                onTap: () => setState(() => _selected = ReciteOutcome.hesitant),
              ),
              OutcomeTile(
                title: l10n.outcomeRedo,
                subtitle: l10n.outcomeRedoSub,
                selected: _selected == ReciteOutcome.redo,
                onTap: () => setState(() => _selected = ReciteOutcome.redo),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _selected == null || _submitting ? null : _continue,
            child: Text(l10n.continueLabel),
          ),
        ),
      ],
    );
  }
}

class _SummaryView extends ConsumerWidget {
  const _SummaryView({required this.session, required this.onBack});

  final RevisionSessionState session;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final allClean =
        session.count(ReciteOutcome.clean) == session.results.length;
    final nextDay = session.nextReviewDay;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 24),
        Icon(
          Icons.check_circle_outline,
          size: 72,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.revisionDoneTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          allClean ? l10n.revisionDoneAllClean : l10n.revisionDoneEncourage,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        _ResultLine(
          label: l10n.outcomeClean,
          count: session.count(ReciteOutcome.clean),
        ),
        _ResultLine(
          label: l10n.outcomeHesitant,
          count: session.count(ReciteOutcome.hesitant),
        ),
        _ResultLine(
          label: l10n.outcomeRedo,
          count: session.count(ReciteOutcome.redo),
        ),
        const SizedBox(height: 24),
        if (session.remainingDue > 0) ...[
          Text(
            l10n.revisionRemaining(session.remainingDue),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ref.invalidate(revisionSessionProvider);
              ref.read(revisionSessionProvider.notifier).start();
            },
            child: Text(l10n.revisionReviseMore),
          ),
          const SizedBox(height: 8),
        ] else if (nextDay != null) ...[
          Text(
            l10n.revisionNextDue(frenchRelativeDay(nextDay, DateTime.now())),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton(onPressed: onBack, child: Text(l10n.revisionBack)),
      ],
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        l10n.revisionResultLine(label, count),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.revisionUpToDateTitle,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.revisionUpToDateSubtitle,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: onBack, child: Text(l10n.revisionBack)),
          ],
        ),
      ),
    );
  }
}
