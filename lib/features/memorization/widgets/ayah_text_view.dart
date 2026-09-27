import 'package:flutter/material.dart';

import '../../../app/sudur_tokens.dart';

/// One ayah's Arabic words, RTL, with optional masking: a hidden word is a
/// "Bleu brume" pill underlined in blue; tapping it reveals the word in
/// "terre cuite" (marking it fragile), per the Masquer step design. With no
/// [hiddenIndices], it's just a plain read-only ayah (Découvrir/Répéter).
class AyahTextView extends StatelessWidget {
  const AyahTextView({
    super.key,
    required this.words,
    this.hiddenIndices = const {},
    this.revealedIndices = const {},
    this.onWordTap,
    this.fontSize = 28,
  });

  final List<String> words;
  final Set<int> hiddenIndices;
  final Set<int> revealedIndices;
  final ValueChanged<int>? onWordTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<SudurTokens>();

    return Wrap(
      alignment: WrapAlignment.center,
      textDirection: TextDirection.rtl,
      spacing: 8,
      runSpacing: 12,
      children: [
        for (var i = 0; i < words.length; i++)
          if (hiddenIndices.contains(i) && !revealedIndices.contains(i))
            GestureDetector(
              onTap: () => onWordTap?.call(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                child: Text('•••', style: TextStyle(fontSize: fontSize * 0.9)),
              ),
            )
          else
            Text(
              words[i],
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: fontSize,
                height: 1.9,
                color: revealedIndices.contains(i)
                    ? tokens?.terracottaText
                    : null,
              ),
            ),
      ],
    );
  }
}
