import 'package:flutter/material.dart';

import '../core/settings/theme_settings.dart';

/// Calm, uncluttered chrome per §7 of the cahier des charges (interface
/// épurée, apaisante — gamification stays on peripheral elements, never on
/// the Quranic content itself). The Quran text always renders in AmiriQuran
/// regardless of [WirdThemeVariant]; only the app's own UI is themed here.
class WirdTheme {
  static ThemeData light(WirdThemeVariant variant) => _build(variant, Brightness.light);

  static ThemeData dark(WirdThemeVariant variant) => _build(variant, Brightness.dark);

  static ThemeData _build(WirdThemeVariant variant, Brightness brightness) {
    final config = kThemeVariantConfigs[variant]!;
    final scheme = ColorScheme.fromSeed(
      seedColor: config.seed,
      brightness: brightness,
      dynamicSchemeVariant: config.schemeVariant,
    );
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(config.cornerRadius));

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: config.uiFontFamily,
      cardTheme: CardThemeData(shape: shape),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shape: shape)),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(shape: shape)),
      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(config.cornerRadius))),
      navigationBarTheme: NavigationBarThemeData(
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(config.cornerRadius)),
      ),
    );
  }
}
