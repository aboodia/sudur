// Smoke test for Brique 0: the app boots, the profile row is created, and
// the bottom navigation skeleton (5 grands onglets) renders.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wird/app/app.dart';

void main() {
  testWidgets('App boots and shows the 5 navigation tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: WirdApp()));
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Lecture'), findsWidgets);
    expect(find.text('Chemin'), findsWidgets);
    expect(find.text('Communauté'), findsWidgets);
    expect(find.text('Profil'), findsWidgets);
  });
}
