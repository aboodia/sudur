import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/community/community_screen.dart';
import '../features/home/home_screen.dart';
import '../features/memorization/memorization_session_screen.dart';
import '../features/memorization/passage_picker_screen.dart';
import '../features/path/path_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/reading/mushaf/mushaf_page_view_screen.dart';
import '../features/reading/reading_screen.dart';
import '../features/reading/surah_reading_screen.dart';
import '../features/review/review_calendar_screen.dart';
import '../features/review/review_session_screen.dart';

/// Squelette de navigation (Brique 0) : les grands onglets existent, même
/// si la plupart des écrans sont encore des placeholders. Mémorisation et
/// Révision ne sont volontairement pas des onglets persistants : ce sont
/// des sessions lancées depuis l'accueil / la lecture (Brique 5).
final appRouter = GoRouter(
  initialLocation: '/accueil',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _SudurScaffold(navigationShell: navigationShell, location: state.uri.toString()),
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
    // Mémorisation (Brique 3) : pas d'onglet dédié (volontaire, voir plus
    // haut) — une session lancée depuis l'Accueil, hors du shell à onglets.
    GoRoute(path: '/memorisation', builder: (context, state) => const PassagePickerScreen()),
    GoRoute(
      path: '/memorisation/session',
      builder: (context, state) {
        final params = state.uri.queryParameters;
        return MemorizationSessionScreen(
          surahNumber: int.parse(params['surah']!),
          startAyah: int.parse(params['start']!),
          endAyah: int.parse(params['end']!),
        );
      },
    ),
    // Révision (Brique 4) : même logique — pas d'onglet dédié.
    GoRoute(path: '/revision', builder: (context, state) => const ReviewCalendarScreen()),
    GoRoute(path: '/revision/session', builder: (context, state) => const ReviewSessionScreen()),
  ],
);

class _SudurScaffold extends StatelessWidget {
  const _SudurScaffold({required this.navigationShell, required this.location});

  final StatefulNavigationShell navigationShell;
  final String location;

  /// Écran de lecture immersif : sourate en continu ou vue Mushaf — c'est
  /// là qu'on replie la barre d'onglets pour laisser toute la place au
  /// texte, plutôt que de garder un lecteur permanent sur tous les écrans.
  bool get _isImmersiveReading => location.contains('/sourate/') || location.contains('/mushaf');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: _isImmersiveReading
            ? const SizedBox(width: double.infinity)
            : NavigationBar(
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
      ),
    );
  }
}
