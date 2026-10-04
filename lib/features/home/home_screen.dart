import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/memorization_repository.dart';
import '../../core/database/profile_repository.dart';
import '../../core/format/french_date.dart';
import '../../core/gamification/achievements_provider.dart';
import '../../core/gamification/memorizer_badge_icon.dart';
import '../../core/gamification/memorizer_profile.dart';
import '../../core/memorization/profile_resolver.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/revision/review_cycle_provider.dart';
import '../../core/stats/progress_stats_provider.dart';
import '../../l10n/app_localizations.dart';
import '../revision/widgets/cycle_card.dart';
import 'widgets/progress_stats_section.dart';

/// The small label at the top of the session card: the text color made for
/// the card's background, slightly softened.
Color sessionLabelColor(ColorScheme scheme) =>
    Color.alphaBlend(scheme.onPrimary.withValues(alpha: 0.85), scheme.primary);

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
    final statsAsync = ref.watch(progressStatsProvider);
    final newBadges = ref.watch(achievementsProvider).value?.newCount ?? 0;
    final name = ref.watch(currentProfileProvider).value?.displayName ?? '';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        frenchDateLabel(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        name.isEmpty
                            ? 'Assalamu alaykum'
                            : 'Assalamu alaykum, $name',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                if ((statsAsync.value?.streakDays ?? 0) > 0)
                  _StreakChip(days: statsAsync.value!.streakDays),
              ],
            ),
            if (newBadges > 0) ...[
              const SizedBox(height: 12),
              _NewBadgesBanner(count: newBadges),
            ],
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
            const CycleCard(),
            dueReviewsAsync.when(
              data: (due) {
                if (due.isEmpty) {
                  // With sourates to review in the cycle, "nothing to
                  // review" would contradict the card just above.
                  if (ref.watch(cycleTodayProvider).value != null) {
                    return const SizedBox.shrink();
                  }
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
                    title: Text(
                      AppLocalizations.of(context).homeReviseVersesTitle,
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context).homeReviseVersesSubtitle(
                        due.length,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/revision'),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            const ProgressStatsSection(),
          ],
        ),
      ),
    );
  }
}

/// The current streak, top right of the greeting — shown only while it is
/// alive, so a day without study never greets the user with a "0".
class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push('/succes'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department_outlined,
              size: 20,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context).statsDays(days),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// A soft nudge when badges were earned since the user last looked.
class _NewBadgesBanner extends StatelessWidget {
  const _NewBadgesBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
      child: ListTile(
        leading: Icon(
          Icons.workspace_premium,
          color: theme.colorScheme.tertiary,
        ),
        title: Text(AppLocalizations.of(context).homeNewBadges(count)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/succes'),
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
                        : '$completedSurahCount sourate(s) · encore $remaining pour atteindre « ${next.info.frenchName} »',
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

/// The sourate's name in French and Arabic on the session card: side by
/// side, or one above the other when the text is enlarged enough that they
/// would not both fit.
class _SessionTitle extends StatelessWidget {
  const _SessionTitle({
    required this.surahName,
    required this.surahArabic,
    required this.color,
  });

  final String surahName;
  final String surahArabic;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = Text(
      surahName,
      style: theme.textTheme.headlineMedium?.copyWith(
        color: color,
        fontFamily: 'CormorantGaramond',
      ),
    );
    final arabic = Text(
      surahArabic,
      textDirection: TextDirection.rtl,
      style: TextStyle(fontFamily: 'AmiriQuran', fontSize: 28, color: color),
    );
    final enlarged = MediaQuery.textScalerOf(context).scale(14) > 14 * 1.4;
    if (enlarged) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          Align(alignment: AlignmentDirectional.centerEnd, child: arabic),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: name),
        arabic,
      ],
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
    // Text colors come from the theme, not a hard-coded white: in dark mode
    // the primary is a light blue and white on it is unreadable.
    final isDark = theme.brightness == Brightness.dark;
    final onCard = theme.colorScheme.onPrimary;
    final onCardMuted = onCard.withValues(alpha: 0.75);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Side by side, or one under the other when the text is enlarged.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                'SESSION DU JOUR · MÉMORISATION',
                // On the card's own color, in the text color made for it: the
                // terracotta used here before was 1.8 : 1.
                style: theme.textTheme.labelMedium?.copyWith(
                  color: sessionLabelColor(theme.colorScheme),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '≈ $estimatedMinutes min',
                style: TextStyle(color: onCardMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SessionTitle(
            surahName: surahName,
            surahArabic: surahArabic,
            color: onCard,
          ),
          Text(
            'Sourate $surahNumber · versets $ayahStart à $ayahEnd',
            style: TextStyle(color: onCardMuted),
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
                      color: onCard.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Découvrir · Répéter · Masquer · Réciter · Enchaîner',
            style: TextStyle(color: onCardMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? onCard : const Color(0xFFF4EFE7),
                foregroundColor: isDark
                    ? theme.colorScheme.primary
                    : const Color(0xFF24427C),
              ),
              onPressed: () => context.push('/memoriser'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Commencer la session',
                      textAlign: TextAlign.center,
                    ),
                  ),
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
