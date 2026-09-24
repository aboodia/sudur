import 'package:flutter/material.dart';

/// Placeholder for Lecture du Coran (Brique 1).
class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lecture')),
      body: const Center(child: Text('Lecture du Coran — à venir (Brique 1)')),
    );
  }
}
