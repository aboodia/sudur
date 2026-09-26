import 'package:flutter/material.dart';

/// The 8 "profils & badges" of the memorization path, from the design
/// `design/Les 8 profils et badges@1x.png` — one per range of memorized
/// sourates (0 to 114). Reused as-is by the Onboarding derived-profile step
/// today, and by the Brique 7 gamification badges later (Le Chemin).
enum MemorizerBadge {
  muqbil,
  mubtadi,
  muthabir,
  salik,
  mujtahid,
  mutqin,
  khatm,
  hafiz,
}

class MemorizerBadgeInfo {
  const MemorizerBadgeInfo({
    required this.minSurahs,
    required this.maxSurahs,
    required this.frenchName,
    required this.transliteration,
    required this.arabicTitle,
    required this.description,
    required this.color,
    required this.icon,
    this.isDark = false,
  });

  final int minSurahs;

  /// Null means "no upper bound" (only [MemorizerBadge.hafiz], where
  /// min == max == 114 anyway — kept for symmetry with [minSurahs]).
  final int? maxSurahs;

  final String frenchName;
  final String transliteration;
  final String arabicTitle;
  final String description;
  final Color color;
  final IconData icon;

  /// Only the Hafiz badge uses a dark card in the design.
  final bool isDark;

  String get rangeLabel {
    if (minSurahs == 0 && maxSurahs == 0) return '0 sourate';
    if (maxSurahs == null || minSurahs == maxSurahs) return '$minSurahs sourates';
    return '$minSurahs – $maxSurahs sourates';
  }
}

extension MemorizerBadgeInfoX on MemorizerBadge {
  MemorizerBadgeInfo get info => switch (this) {
        MemorizerBadge.muqbil => const MemorizerBadgeInfo(
            minSurahs: 0,
            maxSurahs: 0,
            frenchName: "Celui qui s'avance",
            transliteration: 'Al-Muqbil',
            arabicTitle: 'المُقَبِل',
            description:
                "Bienvenue ! « Le meilleur d'entre vous est celui qui apprend le "
                "Coran et l'enseigne. » Ton voyage commence aujourd'hui, un verset "
                'à la fois.',
            color: Color(0xFF7FA37F),
            icon: Icons.spa,
          ),
        MemorizerBadge.mubtadi => const MemorizerBadgeInfo(
            minSurahs: 1,
            maxSurahs: 5,
            frenchName: "L'Initié",
            transliteration: "Al-Mubtadi'",
            arabicTitle: 'المُبتَدِئ',
            description:
                'Félicitations pour tes premières sourates ! Si c\'est encore '
                'difficile, réjouis-toi : celui qui récite avec peine a une '
                'double récompense.',
            color: Color(0xFFC9A33B),
            icon: Icons.local_florist,
          ),
        MemorizerBadge.muthabir => const MemorizerBadgeInfo(
            minSurahs: 6,
            maxSurahs: 20,
            frenchName: 'Le Persévérant',
            transliteration: 'Al-Muthābir',
            arabicTitle: 'المُثَابِر',
            description:
                'Ta constance porte ses fruits. Allah a rendu le Coran facile '
                "pour qui veut s'en souvenir. Continue à ton rythme.",
            color: Color(0xFF3C8C4C),
            icon: Icons.local_fire_department,
          ),
        MemorizerBadge.salik => const MemorizerBadgeInfo(
            minSurahs: 21,
            maxSurahs: 40,
            frenchName: 'Le Cheminant',
            transliteration: 'As-Sālik',
            arabicTitle: 'السالِك',
            description:
                'Tu as parcouru un beau chemin ! Pense à réviser régulièrement : '
                "le Coran s'échappe vite de celui qui ne l'entretient pas.",
            color: Color(0xFF1F3A5F),
            icon: Icons.explore,
          ),
        MemorizerBadge.mujtahid => const MemorizerBadgeInfo(
            minSurahs: 41,
            maxSurahs: 70,
            frenchName: "L'Assidu",
            transliteration: 'Al-Mujtahid',
            arabicTitle: 'المُجتَهِد',
            description:
                "Plus d'un tiers des sourates dans ton cœur, macha'Allah ! Tes "
                "efforts sont une lumière. Garde l'équilibre entre nouveau et "
                'révision.',
            color: Color(0xFFA85C32),
            icon: Icons.menu_book,
          ),
        MemorizerBadge.mutqin => const MemorizerBadgeInfo(
            minSurahs: 71,
            maxSurahs: 100,
            frenchName: "L'Accompli",
            transliteration: 'Al-Mutqin',
            arabicTitle: 'المُتقِن',
            description:
                'Quel accomplissement ! Tu portes une grande part du Livre. Que '
                'chaque récitation te rapproche de Lui.',
            color: Color(0xFF8B94A0),
            icon: Icons.nightlight_round,
          ),
        MemorizerBadge.khatm => const MemorizerBadgeInfo(
            minSurahs: 101,
            maxSurahs: 113,
            frenchName: 'Au seuil du Khatm',
            transliteration: "'Alā 'Atabat al-Khatm",
            arabicTitle: 'على عتبة الختم',
            description:
                'Le but est tout proche ! Tiens bon, chaque sourate restante est '
                'un pas vers la complétion.',
            color: Color(0xFF1E7A6E),
            icon: Icons.notifications,
          ),
        MemorizerBadge.hafiz => const MemorizerBadgeInfo(
            minSurahs: 114,
            maxSurahs: 114,
            frenchName: 'Le Gardien du Coran',
            transliteration: 'Al-Ḥāfiẓ',
            arabicTitle: 'الحافظ',
            description:
                'Mabrouk ! Tu as mémorisé le Coran entier. Il sera dit au '
                'compagnon du Coran : « Récite et élève-toi. » Que la révision '
                'reste ta fidèle compagne.',
            color: Color(0xFFC9A33B),
            icon: Icons.star,
            isDark: true,
          ),
      };
}

/// Which badge a memorizer with [memorizedSurahCount] sourates has reached —
/// mirrors [OnboardingDraft.derivedLevel]'s "hafiz iff 114/114" rule at finer
/// granularity (8 tiers instead of 3).
MemorizerBadge memorizerBadgeForCount(int memorizedSurahCount) {
  if (memorizedSurahCount >= 114) return MemorizerBadge.hafiz;
  if (memorizedSurahCount >= 101) return MemorizerBadge.khatm;
  if (memorizedSurahCount >= 71) return MemorizerBadge.mutqin;
  if (memorizedSurahCount >= 41) return MemorizerBadge.mujtahid;
  if (memorizedSurahCount >= 21) return MemorizerBadge.salik;
  if (memorizedSurahCount >= 6) return MemorizerBadge.muthabir;
  if (memorizedSurahCount >= 1) return MemorizerBadge.mubtadi;
  return MemorizerBadge.muqbil;
}
