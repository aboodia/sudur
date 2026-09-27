import 'package:flutter/material.dart';

/// Placeholder — le nouvel écran "Accueil, session du jour" du parcours de
/// mémorisation (7 écrans) remplace ce contenu en Phase 4.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Accueil — à venir (parcours de mémorisation)'),
        ),
      ),
    );
  }
}
