import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Three chartes graphiques the user can try and switch between. Émeraude
/// and Ivoire & Or are seed-derived Material 3 palettes (each pairs a seed
/// color with a [DynamicSchemeVariant] so they genuinely feel different, not
/// just "same UI, different accent"). Sudur is the brand's own identity
/// board ("Sudur bleu · planche d'identité", 2026) — its colors are exact
/// hex values from that board, not seed-derived, so it's built from a
/// hand-set [ColorScheme] instead (see [ThemeVariantConfig.schemeBuilder]).
/// The Quran text itself always stays in AmiriQuran regardless of variant —
/// this only styles the app chrome, never the Mushaf content.
enum SudurThemeVariant { emeraude, ivoire, sudur }

class ThemeVariantConfig {
  const ThemeVariantConfig({
    required this.label,
    required this.description,
    required this.cornerRadius,
    this.seed,
    this.schemeVariant,
    this.schemeBuilder,
    this.uiFontFamily,
    this.headlineFontFamily,
  });

  final String label;
  final String description;
  final double cornerRadius;

  /// Seed-derived variants (Émeraude, Ivoire & Or) set these two.
  final Color? seed;
  final DynamicSchemeVariant? schemeVariant;

  /// Brand variants (Sudur) set this instead, bypassing `fromSeed` entirely
  /// so the exact identity-board hex values are used verbatim.
  final ColorScheme Function(Brightness)? schemeBuilder;

  /// null = Material default (Roboto-ish system font).
  final String? uiFontFamily;

  /// When set, headline/display/title text styles use this font instead of
  /// [uiFontFamily] — Sudur's "Cormorant Garamond pour les titres, Inter
  /// pour l'interface" split. Null for variants with a single flat font.
  final String? headlineFontFamily;
}

const _sudurPrimary = Color(0xFF24427C); // Bleu Sudur
const _sudurSecondary = Color(0xFFDCE4EF); // Bleu brume
const _sudurTertiary = Color(0xFFB57A64); // Terre cuite
const _sudurBackground = Color(0xFFF4EFE7); // Neutre chaud
const _sudurInk = Color(0xFF181D24); // Encre
const _sudurNight = Color(0xFF101A2C); // Nuit bleue (mode sombre)

ColorScheme _sudurScheme(Brightness brightness) {
  if (brightness == Brightness.light) {
    return ColorScheme.fromSeed(seedColor: _sudurPrimary).copyWith(
      brightness: Brightness.light,
      primary: _sudurPrimary,
      onPrimary: Colors.white,
      secondary: _sudurSecondary,
      onSecondary: _sudurInk,
      tertiary: _sudurTertiary,
      // Ink, not white: white on the terracotta is 3.5 : 1, below the 4.5 : 1
      // legibility minimum.
      onTertiary: _sudurInk,
      surface: _sudurBackground,
      onSurface: _sudurInk,
    );
  }
  return ColorScheme.fromSeed(seedColor: _sudurPrimary, brightness: Brightness.dark).copyWith(
    surface: _sudurNight,
    onSurface: _sudurBackground,
    tertiary: _sudurTertiary,
    onTertiary: _sudurInk,
  );
}

const kThemeVariantConfigs = {
  SudurThemeVariant.emeraude: ThemeVariantConfig(
    label: 'Émeraude',
    description: 'Vert profond et apaisant.',
    seed: Color(0xFF2F6F5E),
    schemeVariant: DynamicSchemeVariant.tonalSpot,
    cornerRadius: 16,
  ),
  SudurThemeVariant.ivoire: ThemeVariantConfig(
    label: 'Ivoire & Or',
    description: 'Tons chauds de manuscrit ancien, avec la police Amiri.',
    seed: Color(0xFFA9781E),
    schemeVariant: DynamicSchemeVariant.fidelity,
    cornerRadius: 10,
    uiFontFamily: 'Amiri',
  ),
  SudurThemeVariant.sudur: ThemeVariantConfig(
    label: 'Sudur',
    description: 'Bleu profond et terre cuite — l\'identité officielle de l\'application.',
    schemeBuilder: _sudurScheme,
    cornerRadius: 18,
    uiFontFamily: 'Inter',
    headlineFontFamily: 'CormorantGaramond',
  ),
};

const _kThemeVariantKey = 'app.themeVariant';

class ThemeVariantController extends Notifier<SudurThemeVariant> {
  @override
  SudurThemeVariant build() {
    _restore();
    return SudurThemeVariant.sudur;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kThemeVariantKey);
    final match = SudurThemeVariant.values.where((v) => v.name == stored);
    if (match.isNotEmpty) state = match.first;
  }

  Future<void> setVariant(SudurThemeVariant variant) async {
    state = variant;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeVariantKey, variant.name);
  }
}

final themeVariantProvider = NotifierProvider<ThemeVariantController, SudurThemeVariant>(
  ThemeVariantController.new,
);
