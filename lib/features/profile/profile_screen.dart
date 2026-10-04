import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/profile_repository.dart';
import '../../l10n/app_localizations.dart';
import '../wird/widgets/wird_goal_editor.dart';
import 'widgets/reminder_card.dart';
import 'widgets/settings_sections.dart';
import 'widgets/theme_variant_picker.dart';

/// Profil et réglages (Brique 9): who the user is, their study plan, how the
/// text and the audio are presented, the reminder, the look of the app and
/// what is kept on the phone for offline use.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            profileAsync.when(
              data: (profile) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(profile: profile),
                  SettingsHeading(l10n.planTitle),
                  StudyPlanSection(profile: profile),
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Erreur de chargement du profil : $err'),
              ),
            ),
            SettingsHeading(l10n.wirdSettingsTitle),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.wirdSettingsHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const WirdGoalSection(),
                ],
              ),
            ),
            SettingsHeading(l10n.readingTitle),
            const ReadingSection(),
            SettingsHeading(l10n.audioSectionTitle),
            const AudioSection(),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const ReminderCard(),
            const Divider(height: 1),
            const SizedBox(height: 8),
            const ThemeVariantPicker(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.download_for_offline_outlined),
              title: Text(l10n.offlineTitle),
              subtitle: Text(l10n.offlineTileSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/hors-ligne'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text(l10n.successTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/succes'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
