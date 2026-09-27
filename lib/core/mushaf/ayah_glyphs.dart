import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mushaf_font_cache.dart';
import 'mushaf_models.dart';
import 'mushaf_repository.dart';

/// Affiche un ayah avec les glyphes exacts du Mushaf (même police par page,
/// via [MushafFontCache], que l'écran de lecture paginée) plutôt qu'un rendu
/// texte générique — le repère de fin de verset est alors le vrai ornement
/// du Mushaf, puisque c'est simplement le dernier "mot" du flux glyphique
/// (jamais masqué, comme les autres mots ne le sont qu'en phase de
/// masquage). Réutilisé par la Mémorisation (Brique 3, masquage progressif)
/// et la Révision (Brique 4, affichage plein sans masquage).
class AyahGlyphs extends ConsumerWidget {
  const AyahGlyphs({
    super.key,
    required this.mushaf,
    required this.words,
    this.masking = false,
    this.maskLevel = 0,
    this.revealedIndices = const {},
    this.onWordTap,
  });

  final MushafRepository mushaf;
  final List<MushafWord> words;
  final bool masking;
  final int maskLevel;
  final Set<int> revealedIndices;
  final ValueChanged<int>? onWordTap;

  Set<int> _hiddenIndices(int maskableCount) {
    if (!masking) return const {};
    switch (maskLevel) {
      case 0:
        return const {};
      case 1:
        return {for (var i = 1; i < maskableCount; i += 2) i};
      default:
        return {for (var i = 0; i < maskableCount; i++) i};
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (words.isEmpty) return const SizedBox.shrink();

    // Un ayah très long (ex. 2:282, le plus long du Coran) peut être à
    // cheval sur deux pages Mushaf, donc la page se résout mot par mot,
    // pas une seule fois pour tout l'ayah.
    final pageByWordId = {for (final w in words) w.id: mushaf.pageForWordId(w.id)};
    final neededPages = pageByWordId.values.whereType<int>().toSet();

    final fontAsyncs = {for (final page in neededPages) page: ref.watch(mushafPageFontProvider(page))};
    if (fontAsyncs.values.any((a) => a.isLoading)) {
      return const CircularProgressIndicator();
    }
    final families = {
      for (final entry in fontAsyncs.entries)
        if (entry.value.value != null) entry.key: entry.value.value!,
    };
    if (families.length != neededPages.length) {
      return OfflineAyahFallback(
        onRetry: () {
          for (final page in neededPages) {
            ref.invalidate(mushafPageFontProvider(page));
          }
        },
      );
    }

    // Le repère de fin de verset est toujours le dernier "mot" du flux
    // glyphique — jamais masqué, ce n'est pas un mot à mémoriser.
    final maskableCount = words.length - 1;
    final hidden = _hiddenIndices(maskableCount);
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      textDirection: TextDirection.rtl,
      spacing: 8,
      runSpacing: 12,
      children: [
        for (var i = 0; i < words.length; i++)
          if (i < maskableCount && hidden.contains(i) && !revealedIndices.contains(i))
            GestureDetector(
              onTap: () => onWordTap?.call(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('•••', style: TextStyle(fontSize: 26)),
              ),
            )
          else
            Text(
              words[i].text,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: families[pageByWordId[words[i].id]], fontSize: 30, height: 1.9),
            ),
      ],
    );
  }
}

class OfflineAyahFallback extends StatelessWidget {
  const OfflineAyahFallback({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off, size: 40),
        const SizedBox(height: 12),
        const Text('Ce verset nécessite une connexion la première fois.', textAlign: TextAlign.center),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
      ],
    );
  }
}
