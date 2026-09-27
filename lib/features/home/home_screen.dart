import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/memorization_repository.dart';
import '../../core/gamification/memorizer_badge_icon.dart';
import '../../core/gamification/memorizer_profile.dart';
import '../../core/memorization/profile_resolver.dart';
import '../../core/quran_reference/quran_reference_repository.dart';

const _weekdays = [
  'lundi',
  'mardi',
  'mercredi',
  'jeudi',
  'vendredi',
  'samedi',
  'dimanche',
];
const _months = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

String _frenchDateLabel(DateTime date) {
  final weekday = _weekdays[date.weekday - 1];
  final month = _months[date.month - 1];
  return '${weekday[0].toUpperCase()}${weekday.substring(1)} ${date.day} $month';
}

/// "Accueil, session du jour" — la carte de session s'appuie sur le
/// contrôleur de session pour rester cohérente avec ce qui sera réellement
/// lancé (reprise ou nouvelle suggestion), sans dupliquer sa logique.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahProgressAsync = ref.watch(surahProgressProvider);
    final previewAsync = ref.watch(todaysPassagePreviewProvider);
    final dueReviewsAsync = ref.watch(dueReviewsProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              _frenchDateLabel(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Assalamu alaykum',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            surahProgressAsync.when(
              data: (rows) => _ProfileCard(
                completedSurahCount: rows
                    .where((r) => r.completedAt != null)
                    .length,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            previewAsync.when(
              data: (preview) {
                if (preview == null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Mabrouk, tout le Coran est déjà mémorisé !'),
                    ),
                  );
                }
                final surahName =
                    referenceAsync.value
                        ?.surahByNumber(preview.surahNumber)
                        .englishName ??
                    '';
                final surahArabic =
                    referenceAsync.value
                        ?.surahByNumber(preview.surahNumber)
                        .nameArabic ??
                    '';
                final verseCount = preview.ayahEnd - preview.ayahStart + 1;
                final estimatedMinutes = (verseCount * 3).clamp(5, 60);
                return _SessionCard(
                  surahName: surahName,
                  surahArabic: surahArabic,
                  surahNumber: preview.surahNumber,
                  ayahStart: preview.ayahStart,
                  ayahEnd: preview.ayahEnd,
                  estimatedMinutes: estimatedMinutes,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Erreur : $err'),
            ),
            const SizedBox(height: 24),
            Text(
              'AUSSI AUJOURD\'HUI',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            dueReviewsAsync.when(
              data: (due) {
                if (due.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Rien à réviser aujourd\'hui.'),
                    ),
                  );
                }
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.refresh),
                    title: Text('Révision · ${due.length} verset(s)'),
                    subtitle: const Text('À réviser aujourd\'hui'),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.completedSurahCount});

  final int completedSurahCount;

  @override
  Widget build(BuildContext context) {
    final badge = memorizerBadgeForCount(completedSurahCount).info;
    final next = memorizerBadgeForCount(completedSurahCount).next;
    final remaining = surahsToNextBadge(completedSurahCount);

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer
          .withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            MemorizerBadgeIcon(color: badge.color, icon: badge.icon, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${badge.frenchName} · ${badge.arabicTitle}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    next == null
                        ? 'Le sommet est atteint, mabrouk !'
                        : '$completedSurahCount sourate(s) · encore $remaining pour ${next.info.frenchName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard({
    required this.surahName,
    required this.surahArabic,
    required this.surahNumber,
    required this.ayahStart,
    required this.ayahEnd,
    required this.estimatedMinutes,
  });

  final String surahName;
  final String surahArabic;
  final int surahNumber;
  final int ayahStart;
  final int ayahEnd;
  final int estimatedMinutes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SESSION DU JOUR · MÉMORISATION',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFFB57A64),
                ),
              ),
              const Spacer(),
              Text(
                '≈ $estimatedMinutes min',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  surahName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontFamily: 'CormorantGaramond',
                  ),
                ),
              ),
              Text(
                surahArabic,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            'Sourate $surahNumber · versets $ayahStart à $ayahEnd',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (var i = 0; i < 5; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Découvrir · Répéter · Masquer · Réciter · Enchaîner',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF4EFE7),
                foregroundColor: const Color(0xFF24427C),
              ),
              onPressed: () => context.push('/memoriser'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Commencer la session'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
