import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/profile_repository.dart';
import '../core/settings/theme_settings.dart';
import '../features/onboarding/onboarding_flow.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

/// Lets code outside the widget tree (the playback failure host) show a
/// message on whichever screen is open.
final appMessengerKey = GlobalKey<ScaffoldMessengerState>();

class SudurApp extends ConsumerWidget {
  const SudurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(themeVariantProvider);
    final needsOnboardingAsync = ref.watch(needsOnboardingProvider);

    // Brique 2 : tant que l'Onboarding n'est pas terminé, on affiche ce
    // flux linéaire à la place du shell à onglets — pas de redirect
    // go_router, plus simple pour un flux qui ne fait pas de deep-linking.
    // Reloading the profile (a setting stored on it changed) keeps showing
    // the current screen: only the very first load shows the blank one.
    return needsOnboardingAsync.when(
      skipLoadingOnReload: true,
      data: (needsOnboarding) => needsOnboarding
          ? MaterialApp(
              title: 'Sudur',
              scaffoldMessengerKey: appMessengerKey,
              debugShowCheckedModeBanner: false,
              theme: SudurTheme.light(variant),
              darkTheme: SudurTheme.dark(variant),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const OnboardingFlow(),
            )
          : MaterialApp.router(
              title: 'Sudur',
              scaffoldMessengerKey: appMessengerKey,
              debugShowCheckedModeBanner: false,
              theme: SudurTheme.light(variant),
              darkTheme: SudurTheme.dark(variant),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: appRouter,
            ),
      loading: () => MaterialApp(
        scaffoldMessengerKey: appMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: SudurTheme.light(variant),
        darkTheme: SudurTheme.dark(variant),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: SizedBox.shrink()),
      ),
      // Lecture du profil local en échec : on ne bloque pas l'utilisateur
      // sur un écran cassé, on le laisse entrer dans l'app normale.
      error: (_, _) => MaterialApp.router(
        title: 'Sudur',
        scaffoldMessengerKey: appMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: SudurTheme.light(variant),
        darkTheme: SudurTheme.dark(variant),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter,
      ),
    );
  }
}
