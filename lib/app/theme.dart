import 'package:flutter/material.dart';

import '../core/settings/theme_settings.dart';
import 'sudur_tokens.dart';

/// Calm, uncluttered chrome per §7 of the cahier des charges (interface
/// épurée, apaisante — gamification stays on peripheral elements, never on
/// the Quranic content itself). The Quran text always renders in AmiriQuran
/// regardless of [SudurThemeVariant]; only the app's own UI is themed here.
class SudurTheme {
  static ThemeData light(SudurThemeVariant variant) =>
      _build(variant, Brightness.light);

  static ThemeData dark(SudurThemeVariant variant) =>
      _build(variant, Brightness.dark);

  static ThemeData _build(SudurThemeVariant variant, Brightness brightness) {
    final config = kThemeVariantConfigs[variant]!;
    final scheme = config.schemeBuilder != null
        ? config.schemeBuilder!(brightness)
        : ColorScheme.fromSeed(
            seedColor: config.seed!,
            brightness: brightness,
            dynamicSchemeVariant: config.schemeVariant!,
          );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(config.cornerRadius),
    );
    final tokens = config.schemeBuilder != null
        ? SudurTokens.brand()
        : SudurTokens.fromScheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: config.uiFontFamily,
      textTheme: config.headlineFontFamily == null
          ? null
          : _headlineSplitTextTheme(config.headlineFontFamily!),
      cardTheme: CardThemeData(shape: shape),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: shape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: shape),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.cornerRadius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.cornerRadius),
        ),
        labelTextStyle: navigationLabelStyle(scheme),
      ),
      extensions: [tokens],
    );
  }

  /// Sudur's "Cormorant Garamond pour les titres, Inter pour l'interface" —
  /// only the display/headline/title roles switch font; body/label text
  /// stays on the variant's flat `uiFontFamily` (set separately via
  /// [ThemeData.fontFamily]).
  static TextTheme _headlineSplitTextTheme(String headlineFontFamily) {
    // Lining figures: Cormorant's default old-style ones make a "1" look like
    // a small capital I ("verset I") and let digits drop below the line.
    final style = TextStyle(
      fontFamily: headlineFontFamily,
      fontFeatures: const [FontFeature.liningFigures()],
    );
    return TextTheme(
      displayLarge: style,
      displayMedium: style,
      displaySmall: style,
      headlineLarge: style,
      headlineMedium: style,
      headlineSmall: style,
      titleLarge: style,
    );
  }
}

/// Tab labels of the bottom bar. The default style spaces the letters out,
/// which can push the longest label past the width of its tab on a phone
/// and wrap its last letter onto a second line (as "Communauté" did with
/// five tabs); without the extra spacing labels stay on one line.
WidgetStateProperty<TextStyle?> navigationLabelStyle(ColorScheme scheme) =>
    WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        fontSize: 12,
        letterSpacing: 0,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
      );
    });
