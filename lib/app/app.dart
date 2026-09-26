import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/profile_repository.dart';
import '../core/settings/theme_settings.dart';
import '../features/onboarding/onboarding_flow.dart';
import 'router.dart';
import 'theme.dart';

class WirdApp extends ConsumerWidget {
  const WirdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(themeVariantProvider);
    final needsOnboardingAsync = ref.watch(needsOnboardingProvider);

    // Brique 2 : tant que l'Onboarding n'est pas terminé, on affiche ce
    // flux linéaire à la place du shell à onglets — pas de redirect
    // go_router, plus simple pour un flux qui ne fait pas de deep-linking.
    return needsOnboardingAsync.when(
      data: (needsOnboarding) => needsOnboarding
          ? MaterialApp(
              title: 'Wird',
              debugShowCheckedModeBanner: false,
              theme: WirdTheme.light(variant),
              darkTheme: WirdTheme.dark(variant),
              home: const OnboardingFlow(),
            )
          : MaterialApp.router(
              title: 'Wird',
              debugShowCheckedModeBanner: false,
              theme: WirdTheme.light(variant),
              darkTheme: WirdTheme.dark(variant),
              routerConfig: appRouter,
            ),
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: WirdTheme.light(variant),
        darkTheme: WirdTheme.dark(variant),
        home: const Scaffold(body: SizedBox.shrink()),
      ),
      // Lecture du profil local en échec : on ne bloque pas l'utilisateur
      // sur un écran cassé, on le laisse entrer dans l'app normale.
      error: (_, _) => MaterialApp.router(
        title: 'Wird',
        debugShowCheckedModeBanner: false,
        theme: WirdTheme.light(variant),
        darkTheme: WirdTheme.dark(variant),
        routerConfig: appRouter,
      ),
    );
  }
}
