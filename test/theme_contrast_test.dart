// Readability of the three chartes graphiques, light and dark: the text
// colors each theme pairs with its backgrounds must be legible (WCAG AA,
// contrast of at least 4.5 : 1 for normal text).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/app/theme.dart';
import 'package:sudur/core/settings/theme_settings.dart';
import 'package:sudur/features/home/home_screen.dart';
import 'package:sudur/features/reading/mushaf/mushaf_line_row.dart';

/// WCAG contrast ratio between two colors.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final light = la > lb ? la : lb;
  final dark = la > lb ? lb : la;
  return (light + 0.05) / (dark + 0.05);
}

void main() {
  const minimum = 4.5;

  test('the contrast helper is right on the extremes', () {
    expect(contrast(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(contrast(Colors.white, Colors.white), closeTo(1, 0.001));
  });

  for (final variant in SudurThemeVariant.values) {
    for (final brightness in Brightness.values) {
      test(
        'text is legible on its background (${variant.name}, ${brightness.name})',
        () {
          final theme = brightness == Brightness.light
              ? SudurTheme.light(variant)
              : SudurTheme.dark(variant);
          final s = theme.colorScheme;
          final pairs = <String, (Color, Color)>{
            'onSurface on surface': (s.onSurface, s.surface),
            'onSurfaceVariant on surface': (s.onSurfaceVariant, s.surface),
            'onPrimary on primary': (s.onPrimary, s.primary),
            'primary on surface': (s.primary, s.surface),
            'onPrimaryContainer on primaryContainer': (
              s.onPrimaryContainer,
              s.primaryContainer,
            ),
            'onSecondaryContainer on secondaryContainer': (
              s.onSecondaryContainer,
              s.secondaryContainer,
            ),
            'onTertiaryContainer on tertiaryContainer': (
              s.onTertiaryContainer,
              s.tertiaryContainer,
            ),
            'onTertiary on tertiary': (s.onTertiary, s.tertiary),
            'onError on error': (s.onError, s.error),
          };
          final failures = [
            for (final e in pairs.entries)
              if (contrast(e.value.$1, e.value.$2) < minimum)
                '${e.key}: ${contrast(e.value.$1, e.value.$2).toStringAsFixed(2)}',
          ];
          expect(failures, isEmpty);
        },
      );
    }
  }

  // The session card on the Accueil writes its small label in the text color
  // made for the primary color, in light and dark.
  for (final variant in SudurThemeVariant.values) {
    for (final brightness in Brightness.values) {
      test(
        'the Accueil session card label is legible (${variant.name}, ${brightness.name})',
        () {
          final theme = brightness == Brightness.light
              ? SudurTheme.light(variant)
              : SudurTheme.dark(variant);
          final s = theme.colorScheme;
          expect(
            contrast(sessionLabelColor(s), s.primary),
            greaterThanOrEqualTo(minimum),
          );
        },
      );
    }
  }

  // A Mushaf page is dark ink on light paper in every theme: the tajweed
  // font's plain letters are black, and vanish on a dark background.
  for (final variant in SudurThemeVariant.values) {
    for (final brightness in Brightness.values) {
      test(
        'the Mushaf page is readable (${variant.name}, ${brightness.name})',
        () {
          final theme = brightness == Brightness.light
              ? SudurTheme.light(variant)
              : SudurTheme.dark(variant);
          final page = MushafPaper.of(theme);
          // The paper itself is light even when the theme is dark.
          expect(page.paper.computeLuminance(), greaterThan(0.5));
          expect(contrast(page.ink, page.paper), greaterThanOrEqualTo(7.0));
          // The ink stays legible on the word being played.
          // (The highlight is drawn over the paper, so it is judged blended.)
          final played = Color.alphaBlend(page.highlight, page.paper);
          expect(contrast(page.ink, played), greaterThanOrEqualTo(4.5));
          // Pure black glyphs (the font's own color) show up on the paper.
          expect(contrast(Colors.black, page.paper), greaterThanOrEqualTo(7.0));
        },
      );
    }
  }
}
