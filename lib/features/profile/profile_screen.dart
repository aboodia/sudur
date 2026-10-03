import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/profile_repository.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/theme_variant_picker.dart';

/// Placeholder for Profil et paramètres (Brique 9 for the advanced parts).
/// Already wired to the local profile row so Brique 0's data layer
/// (fondations) is exercised end-to-end, plus a live charte graphique
/// picker (3 themes to try and switch between).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            profileAsync.when(
              data: (profile) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profil local créé (id: ${profile.id})'),
                    Text('Niveau : ${profile.memorizationLevel}'),
                    Text(
                      'Objectif quotidien : ${profile.dailyTargetMinutes} min',
                    ),
                    const SizedBox(height: 4),
                    const Text('Réglages complets — à venir (Brique 9)'),
                  ],
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Erreur de chargement du profil : $err'),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text(AppLocalizations.of(context).successTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/succes'),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            const ThemeVariantPicker(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
