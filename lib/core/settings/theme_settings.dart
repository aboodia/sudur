import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Three chartes graphiques the user can try and switch between. Each pairs
/// a seed color with a Material 3 [DynamicSchemeVariant] (not just a hue
/// swap — the variant changes how the whole tonal palette is generated, so
/// each option genuinely feels different, not just "same UI, different
/// accent"). The Quran text itself always stays in AmiriQuran regardless of
/// variant — this only styles the app chrome, never the Mushaf content.
enum WirdThemeVariant { emeraude, ivoire, nuitBleue }

class ThemeVariantConfig {
  const ThemeVariantConfig({
    required this.label,
    required this.description,
    required this.seed,
    required this.schemeVariant,
    required this.cornerRadius,
    this.uiFontFamily,
  });

  final String label;
  final String description;
  final Color seed;
  final DynamicSchemeVariant schemeVariant;
  final double cornerRadius;

  /// null = Material default (Roboto-ish system font).
  final String? uiFontFamily;
}

const kThemeVariantConfigs = {
  WirdThemeVariant.emeraude: ThemeVariantConfig(
    label: 'Émeraude',
    description: 'Vert profond et apaisant, l\'identité par défaut de Wird.',
    seed: Color(0xFF2F6F5E),
    schemeVariant: DynamicSchemeVariant.tonalSpot,
    cornerRadius: 16,
  ),
  WirdThemeVariant.ivoire: ThemeVariantConfig(
    label: 'Ivoire & Or',
    description: 'Tons chauds de manuscrit ancien, avec la police Amiri.',
    seed: Color(0xFFA9781E),
    schemeVariant: DynamicSchemeVariant.fidelity,
    cornerRadius: 10,
    uiFontFamily: 'Amiri',
  ),
  WirdThemeVariant.nuitBleue: ThemeVariantConfig(
    label: 'Nuit Bleue',
    description: 'Bleu nocturne contrasté, confortable pour lire le soir.',
    seed: Color(0xFF223A70),
    schemeVariant: DynamicSchemeVariant.vibrant,
    cornerRadius: 22,
  ),
};

const _kThemeVariantKey = 'app.themeVariant';

class ThemeVariantController extends Notifier<WirdThemeVariant> {
  @override
  WirdThemeVariant build() {
    _restore();
    return WirdThemeVariant.emeraude;
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kThemeVariantKey);
    final match = WirdThemeVariant.values.where((v) => v.name == stored);
    if (match.isNotEmpty) state = match.first;
  }

  Future<void> setVariant(WirdThemeVariant variant) async {
    state = variant;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeVariantKey, variant.name);
  }
}

final themeVariantProvider = NotifierProvider<ThemeVariantController, WirdThemeVariant>(
  ThemeVariantController.new,
);
