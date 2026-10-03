import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/app/theme.dart';
import 'package:sudur/core/settings/theme_settings.dart';

void main() {
  // With the default letter spacing a long tab label wrapped onto a second
  // line on a phone ("Communauté", when there were five tabs). The test environment
  // does not have the app's font, so it checks the cause: no extra spacing,
  // one line's worth of size, in every theme.
  for (final variant in SudurThemeVariant.values) {
    for (final brightness in Brightness.values) {
      test(
        'tab labels are not letter-spaced (${variant.name}, ${brightness.name})',
        () {
          final theme = brightness == Brightness.light
              ? SudurTheme.light(variant)
              : SudurTheme.dark(variant);
          final style = theme.navigationBarTheme.labelTextStyle!;

          for (final states in [
            <WidgetState>{},
            {WidgetState.selected},
          ]) {
            final resolved = style.resolve(states)!;
            expect(resolved.letterSpacing, 0);
            expect(resolved.fontSize, lessThanOrEqualTo(12));
            expect(resolved.color, isNotNull);
          }
        },
      );
    }
  }
}
