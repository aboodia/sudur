import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/memorization_repository.dart';
import '../../core/memorization/passage_suggestion.dart';
import '../../core/quran_reference/quran_reference_models.dart';
import '../../core/quran_reference/quran_reference_repository.dart';

/// Découpage assisté (Brique 3) : propose le prochain passage (1-3 ayahs)
/// dans l'ordre du Coran, avec un choix manuel toujours disponible.
class PassagePickerScreen extends ConsumerStatefulWidget {
  const PassagePickerScreen({super.key});

  @override
  ConsumerState<PassagePickerScreen> createState() => _PassagePickerScreenState();
}

class _PassagePickerScreenState extends ConsumerState<PassagePickerScreen> {
  bool _manual = false;
  int? _manualSurah;
  int _manualStart = 1;
  int _manualEnd = 1;

  void _start(int surah, int start, int end) {
    context.push('/memorisation/session?surah=$surah&start=$start&end=$end');
  }

  @override
  Widget build(BuildContext context) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    final unitsAsync = ref.watch(memorizationUnitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mémorisation')),
      body: referenceAsync.when(
        data: (reference) => unitsAsync.when(
          data: (units) {
            final suggestion = suggestNextPassage(reference, units);
            final manualSurah = reference.surahByNumber(_manualSurah ?? reference.surahs.first.number);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (suggestion != null)
                  _SuggestionCard(
                    reference: reference,
                    suggestion: suggestion,
                    onStart: () => _start(suggestion.surahNumber, suggestion.startAyah, suggestion.endAyah),
                  )
                else
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Mashallah, tout le Coran est déjà couvert par vos passages !'),
                    ),
                  ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => setState(() => _manual = !_manual),
                    child: Text(_manual ? 'Masquer le choix manuel' : 'Choisir un autre passage'),
                  ),
                ),
                if (_manual)
                  _ManualPicker(
                    reference: reference,
                    surah: manualSurah,
                    startAyah: _manualStart,
                    endAyah: _manualEnd,
                    onSurahChanged: (number) => setState(() {
                      _manualSurah = number;
                      _manualStart = 1;
                      _manualEnd = 1;
                    }),
                    onStartChanged: (value) => setState(() {
                      _manualStart = value;
                      if (_manualEnd < value) _manualEnd = value;
                      if (_manualEnd > value + 2) _manualEnd = value + 2;
                    }),
                    onEndChanged: (value) => setState(() => _manualEnd = value),
                    onStart: () => _start(manualSurah.number, _manualStart, _manualEnd),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erreur : $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.reference, required this.suggestion, required this.onStart});

  final QuranReferenceRepository reference;
  final NextPassage suggestion;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final surah = reference.surahByNumber(suggestion.surahNumber);
    final theme = Theme.of(context);
    final label = suggestion.startAyah == suggestion.endAyah
        ? 'verset ${suggestion.startAyah}'
        : 'versets ${suggestion.startAyah} à ${suggestion.endAyah}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prochain passage suggéré', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Text('${surah.englishName} — $label', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            FilledButton(onPressed: onStart, child: const Text('Commencer')),
          ],
        ),
      ),
    );
  }
}

class _ManualPicker extends StatelessWidget {
  const _ManualPicker({
    required this.reference,
    required this.surah,
    required this.startAyah,
    required this.endAyah,
    required this.onSurahChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onStart,
  });

  final QuranReferenceRepository reference;
  final Surah surah;
  final int startAyah;
  final int endAyah;
  final ValueChanged<int> onSurahChanged;
  final ValueChanged<int> onStartChanged;
  final ValueChanged<int> onEndChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final maxEnd = (startAyah + 2).clamp(startAyah, surah.numberOfAyahs);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              initialValue: surah.number,
              decoration: const InputDecoration(labelText: 'Sourate'),
              items: [
                for (final s in reference.surahs)
                  DropdownMenuItem(value: s.number, child: Text('${s.number}. ${s.englishName}')),
              ],
              onChanged: (value) {
                if (value != null) onSurahChanged(value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: startAyah,
                    decoration: const InputDecoration(labelText: 'Du verset'),
                    items: [
                      for (var a = 1; a <= surah.numberOfAyahs; a++)
                        DropdownMenuItem(value: a, child: Text('$a')),
                    ],
                    onChanged: (value) {
                      if (value != null) onStartChanged(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: endAyah,
                    decoration: const InputDecoration(labelText: 'Au verset'),
                    items: [
                      for (var a = startAyah; a <= maxEnd; a++) DropdownMenuItem(value: a, child: Text('$a')),
                    ],
                    onChanged: (value) {
                      if (value != null) onEndChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Maximum 3 versets par passage.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onStart, child: const Text('Commencer ce passage')),
          ],
        ),
      ),
    );
  }
}
