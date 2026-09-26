import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder for the Tableau de bord (Brique 5) — porte déjà le point
/// d'entrée de la Mémorisation (Brique 3), volontairement sans onglet dédié
/// (voir router.dart) : "une session lancée depuis l'accueil".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tableau de bord — à venir (Brique 5)'),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.push('/memorisation'),
                  icon: const Icon(Icons.school),
                  label: const Text('Démarrer une session de mémorisation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
