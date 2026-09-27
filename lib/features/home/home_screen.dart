import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Placeholder for the Tableau de bord (Brique 5) — porte déjà les points
/// d'entrée de la Mémorisation (Brique 3) et de la Révision (Brique 4),
/// volontairement sans onglet dédié (voir router.dart) : "une session
/// lancée depuis l'accueil".
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
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push('/revision'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réviser'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
