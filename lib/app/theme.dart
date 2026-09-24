import 'package:flutter/material.dart';

/// Calm, uncluttered palette per §7 of the cahier des charges (interface
/// épurée, apaisante — gamification stays on peripheral elements, never on
/// the Quranic content itself).
class WirdTheme {
  static const _seed = Color(0xFF2F6F5E); // deep, calm teal-green

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        brightness: Brightness.light,
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      );
}
