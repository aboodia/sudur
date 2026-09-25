import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/theme_settings.dart';

/// Lets the user try and switch between the 3 chartes graphiques live —
/// each card previews its own palette so the choice is visual, not just a
/// name in a list.
class ThemeVariantPicker extends ConsumerWidget {
  const ThemeVariantPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(themeVariantProvider);
    final controller = ref.read(themeVariantProvider.notifier);
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Charte graphique', style: Theme.of(context).textTheme.titleMedium),
        ),
        for (final variant in WirdThemeVariant.values)
          _ThemeVariantCard(
            variant: variant,
            isSelected: variant == selected,
            brightness: brightness,
            onTap: () => controller.setVariant(variant),
          ),
      ],
    );
  }
}

class _ThemeVariantCard extends StatelessWidget {
  const _ThemeVariantCard({
    required this.variant,
    required this.isSelected,
    required this.brightness,
    required this.onTap,
  });

  final WirdThemeVariant variant;
  final bool isSelected;
  final Brightness brightness;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final config = kThemeVariantConfigs[variant]!;
    final previewScheme = ColorScheme.fromSeed(
      seedColor: config.seed,
      brightness: brightness,
      dynamicSchemeVariant: config.schemeVariant,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(config.cornerRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _Swatch(color: previewScheme.primary),
              _Swatch(color: previewScheme.secondary),
              _Swatch(color: previewScheme.tertiary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.label,
                      style: TextStyle(
                        fontFamily: config.uiFontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      config.description,
                      style: TextStyle(fontFamily: config.uiFontFamily, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? previewScheme.primary : Theme.of(context).colorScheme.outline,
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
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
