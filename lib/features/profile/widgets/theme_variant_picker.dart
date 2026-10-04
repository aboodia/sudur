import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/theme_settings.dart';

/// Lets the user try and switch between the 3 chartes graphiques live —
/// each choice previews its own palette so the choice is visual, not just a
/// name in a list. Three side by side rather than three tall cards, with the
/// description of the one chosen underneath.
class ThemeVariantPicker extends ConsumerWidget {
  const ThemeVariantPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(themeVariantProvider);
    final controller = ref.read(themeVariantProvider.notifier);
    final brightness = Theme.of(context).brightness;
    final theme = Theme.of(context);
    final chosen = kThemeVariantConfigs[selected]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text('Charte graphique', style: theme.textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final variant in SudurThemeVariant.values) ...[
                  if (variant != SudurThemeVariant.values.first)
                    const SizedBox(width: 8),
                  Expanded(
                    child: _ThemeVariantChoice(
                      variant: variant,
                      isSelected: variant == selected,
                      brightness: brightness,
                      onTap: () => controller.setVariant(variant),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(chosen.description, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}

class _ThemeVariantChoice extends StatelessWidget {
  const _ThemeVariantChoice({
    required this.variant,
    required this.isSelected,
    required this.brightness,
    required this.onTap,
  });

  final SudurThemeVariant variant;
  final bool isSelected;
  final Brightness brightness;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final config = kThemeVariantConfigs[variant]!;
    final theme = Theme.of(context);
    final previewScheme = config.schemeBuilder != null
        ? config.schemeBuilder!(brightness)
        : ColorScheme.fromSeed(
            seedColor: config.seed!,
            brightness: brightness,
            dynamicSchemeVariant: config.schemeVariant!,
          );

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        borderRadius: BorderRadius.circular(config.cornerRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? previewScheme.primary
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(config.cornerRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Swatch(color: previewScheme.primary),
                  _Swatch(color: previewScheme.secondary),
                  _Swatch(color: previewScheme.tertiary),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                config.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: config.headlineFontFamily ?? config.uiFontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 18,
                color: isSelected
                    ? previewScheme.primary
                    : theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
