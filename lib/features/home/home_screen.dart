import 'package:flutter/material.dart';

/// Placeholder for the Tableau de bord (Brique 5). Brique 0 only needs the
/// tab to exist and render.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Center(child: Text('Tableau de bord — à venir (Brique 5)')),
      ),
    );
  }
}
