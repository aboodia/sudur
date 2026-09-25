import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/community/community_screen.dart';
import '../features/home/home_screen.dart';
import '../features/path/path_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/reading/mushaf/mushaf_page_view_screen.dart';
import '../features/reading/reading_screen.dart';
import '../features/reading/surah_reading_screen.dart';
import '../features/reading/widgets/audio_player_bar.dart';

/// Squelette de navigation (Brique 0) : les grands onglets existent, même
/// si la plupart des écrans sont encore des placeholders. Mémorisation et
/// Révision ne sont volontairement pas des onglets persistants : ce sont
/// des sessions lancées depuis l'accueil / la lecture (Brique 5).
final appRouter = GoRouter(
  initialLocation: '/accueil',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _WirdScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/accueil', builder: (context, state) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/lecture',
            builder: (context, state) => const ReadingScreen(),
            routes: [
              GoRoute(
                path: 'sourate/:number',
                builder: (context, state) {
                  final surahNumber = int.parse(state.pathParameters['number']!);
                  final ayah = state.uri.queryParameters['ayah'];
                  return SurahReadingScreen(
                    surahNumber: surahNumber,
                    initialAyah: ayah != null ? int.tryParse(ayah) : null,
                  );
                },
              ),
              GoRoute(
                path: 'mushaf',
                builder: (context, state) {
                  final page = state.uri.queryParameters['page'];
                  return MushafPageViewScreen(initialPage: int.tryParse(page ?? '') ?? 1);
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/chemin', builder: (context, state) => const PathScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/communaute', builder: (context, state) => const CommunityScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profil', builder: (context, state) => const ProfileScreen()),
        ]),
      ],
    ),
  ],
);

class _WirdScaffold extends StatelessWidget {
  const _WirdScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      // Le mini-lecteur vit ici, au niveau du shell, et non dans chaque
      // écran de lecture : il reste donc visible (et permet de retrouver
      // ce qui joue) sur n'importe quel onglet, y compris en revenant sur
      // l'app depuis l'arrière-plan.
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AudioPlayerBar(),
          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
              NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Lecture'),
              NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Chemin'),
              NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Communauté'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
            ],
          ),
        ],
      ),
    );
  }
}
