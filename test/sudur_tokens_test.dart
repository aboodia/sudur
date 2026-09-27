import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/app/sudur_tokens.dart';
import 'package:sudur/app/theme.dart';
import 'package:sudur/core/settings/theme_settings.dart';

void main() {
  test('the Sudur variant carries the exact brand tokens', () {
    final theme = SudurTheme.light(SudurThemeVariant.sudur);
    final tokens = theme.extension<SudurTokens>()!;
    expect(tokens.cardSurface, const Color(0xFFFBF8F3));
    expect(tokens.border, const Color(0xFFE3DCD0));
    expect(tokens.terracottaText, const Color(0xFF9A5E48));
  });

  test('seed-derived variants still expose a SudurTokens extension', () {
    final theme = SudurTheme.light(SudurThemeVariant.emeraude);
    expect(theme.extension<SudurTokens>(), isNotNull);
  });

  test('lerp between two SudurTokens blends every color', () {
    const a = SudurTokens(
      cardSurface: Colors.black,
      border: Colors.black,
      terracottaText: Colors.black,
    );
    const b = SudurTokens(
      cardSurface: Colors.white,
      border: Colors.white,
      terracottaText: Colors.white,
    );
    final mid = a.lerp(b, 0.5);
    expect(mid.cardSurface.r, closeTo(0.5, 0.01));
  });
}
