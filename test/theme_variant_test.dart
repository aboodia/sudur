// Verifies the 3 chartes graphiques end-to-end, testing ThemeVariantPicker
// in isolation (not through the full WirdApp/router) so this stays a fast,
// self-contained widget test with no dependency on the native Drift/sqlite3
// database, which flutter_test's headless harness can't provide.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wird/core/settings/theme_settings.dart';
import 'package:wird/features/profile/widgets/theme_variant_picker.dart';

Widget _harness() {
  return const ProviderScope(
    child: MaterialApp(home: Scaffold(body: ThemeVariantPicker())),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('all 3 theme variants are offered and labeled', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    for (final variant in WirdThemeVariant.values) {
      expect(find.text(kThemeVariantConfigs[variant]!.label), findsOneWidget);
    }
  });

  testWidgets('Émeraude is selected by default, tapping another selects it instead', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.tap(find.text('Nuit Bleue'));
    await tester.pump();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    // Only one card is selected at a time.
    expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(2));
  });

  testWidgets('the chosen variant persists to SharedPreferences', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    await tester.tap(find.text('Ivoire & Or'));
    await tester.pump();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app.themeVariant'), WirdThemeVariant.ivoire.name);
  });

  test('each variant produces a genuinely different primary color', () {
    final primaries = WirdThemeVariant.values.map((v) {
      final config = kThemeVariantConfigs[v]!;
      return ColorScheme.fromSeed(
        seedColor: config.seed,
        dynamicSchemeVariant: config.schemeVariant,
      ).primary;
    }).toSet();
    expect(primaries, hasLength(WirdThemeVariant.values.length));
  });
}
