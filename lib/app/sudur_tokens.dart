import 'package:flutter/material.dart';

/// Design tokens from the "Sudur bleu" identity board not directly covered
/// by Material's [ColorScheme] — card surface, hairline borders, and the
/// "terre cuite" text color used sparingly for accents (fragile words,
/// warm callouts). Always present regardless of [SudurThemeVariant]: the
/// other two seed-derived variants get reasonable equivalents computed
/// from their own [ColorScheme] rather than the exact brand hex values,
/// which only apply to the Sudur variant itself.
class SudurTokens extends ThemeExtension<SudurTokens> {
  const SudurTokens({
    required this.cardSurface,
    required this.border,
    required this.terracottaText,
  });

  /// The Sudur identity board's exact values (`#FBF8F3` cards, `#E3DCD0`
  /// borders, `#9A5E48` terre cuite text) — used only by the Sudur variant.
  factory SudurTokens.brand() => const SudurTokens(
    cardSurface: Color(0xFFFBF8F3),
    border: Color(0xFFE3DCD0),
    terracottaText: Color(0xFF9A5E48),
  );

  /// Derived from a seed-generated [ColorScheme] for the other variants,
  /// which the identity board doesn't define tokens for.
  factory SudurTokens.fromScheme(ColorScheme scheme) => SudurTokens(
    cardSurface: scheme.surfaceContainerHighest,
    border: scheme.outlineVariant,
    terracottaText: scheme.tertiary,
  );

  final Color cardSurface;
  final Color border;
  final Color terracottaText;

  @override
  SudurTokens copyWith({
    Color? cardSurface,
    Color? border,
    Color? terracottaText,
  }) => SudurTokens(
    cardSurface: cardSurface ?? this.cardSurface,
    border: border ?? this.border,
    terracottaText: terracottaText ?? this.terracottaText,
  );

  @override
  SudurTokens lerp(ThemeExtension<SudurTokens>? other, double t) {
    if (other is! SudurTokens) return this;
    return SudurTokens(
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      border: Color.lerp(border, other.border, t)!,
      terracottaText: Color.lerp(terracottaText, other.terracottaText, t)!,
    );
  }
}
