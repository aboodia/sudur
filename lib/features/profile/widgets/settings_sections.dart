import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/reciter.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/profile_repository.dart';
import '../../../core/settings/audio_settings.dart';
import '../../../core/settings/reading_settings.dart';
import '../../../core/stats/goals_provider.dart';
import '../../../l10n/app_localizations.dart';

/// Title of a group of settings.
class SettingsHeading extends StatelessWidget {
  const SettingsHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

String levelLabel(AppLocalizations l10n, String level) => switch (level) {
  'hafiz' => l10n.levelHafiz,
  'en_cours' => l10n.levelOngoing,
  _ => l10n.levelBeginner,
};

/// The name the user goes by, and their level.
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key, required this.profile});

  final UserProfile profile;

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => _NameDialog(initial: profile.displayName),
    );
    if (name == null) return;
    await ref
        .read(userProfileRepositoryProvider)
        .updateProfile(id: profile.id, displayName: name);
    ref.invalidate(currentProfileProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final name = profile.displayName;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(l10n.profileNameLabel),
          subtitle: Text(name.isEmpty ? l10n.profileNameEmpty : name),
          trailing: const Icon(Icons.edit_outlined, size: 20),
          onTap: () => _editName(context, ref),
        ),
        ListTile(
          leading: const Icon(Icons.flag_outlined),
          title: Text(l10n.profileLevel),
          trailing: Text(
            levelLabel(l10n, profile.memorizationLevel),
            style: theme.textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

/// Asks for the name. The text field is owned by the dialog itself: it must
/// outlive the dialog's closing animation.
class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.initial});

  final String initial;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.profileNameLabel),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        maxLength: 40,
        decoration: InputDecoration(hintText: l10n.profileNameHint),
        onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.offlineConfirmNo),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(l10n.profileNameSave),
        ),
      ],
    );
  }
}

/// Time per day and the days the user is available — the plan the goals,
/// the reminder and the streak are all built on.
class StudyPlanSection extends ConsumerWidget {
  const StudyPlanSection({super.key, required this.profile});

  final UserProfile profile;

  static const minMinutes = 5;
  static const maxMinutes = 180;
  static const minutesStep = 5;
  static const _dayLabels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  Future<void> _save(WidgetRef ref, {int? minutes, int? mask}) async {
    await ref
        .read(userProfileRepositoryProvider)
        .updateProfile(
          id: profile.id,
          dailyTargetMinutes: minutes,
          availableDaysMask: mask,
        );
    // The goals, the reminder and the streak are all computed from these.
    ref.invalidate(currentProfileProvider);
    ref.invalidate(goalsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final minutes = profile.dailyTargetMinutes.clamp(minMinutes, maxMinutes);
    final mask = profile.availableDaysMask;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.planMinutes, style: theme.textTheme.bodyLarge),
              ),
              IconButton.outlined(
                tooltip: l10n.goalEditDecrease,
                onPressed: minutes > minMinutes
                    ? () => _save(ref, minutes: minutes - minutesStep)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 72,
                child: Text(
                  l10n.planMinutesValue(minutes),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton.outlined(
                tooltip: l10n.goalEditIncrease,
                onPressed: minutes < maxMinutes
                    ? () => _save(ref, minutes: minutes + minutesStep)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.planDays, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < 7; i++)
                FilterChip(
                  label: Text(_dayLabels[i]),
                  selected: mask & (1 << i) != 0,
                  onSelected: (on) {
                    final next = on ? mask | (1 << i) : mask & ~(1 << i);
                    if (next == 0) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text(l10n.planDaysNeedOne)),
                        );
                      return;
                    }
                    _save(ref, mask: next);
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.planExplain, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// How the Quran text is shown.
class ReadingSection extends ConsumerWidget {
  const ReadingSection({super.key, this.showHeading = false});

  final bool showHeading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(readingSettingsProvider);
    final controller = ref.read(readingSettingsProvider.notifier);

    String label(ReadingDisplayMode m) => switch (m) {
      ReadingDisplayMode.arabicOnly => l10n.readingModeArabic,
      ReadingDisplayMode.transliteration => l10n.readingModeTranslit,
      ReadingDisplayMode.bilingual => l10n.readingModeBilingual,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.readingMode, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          SegmentedButton<ReadingDisplayMode>(
            showSelectedIcon: false,
            segments: [
              for (final m in ReadingDisplayMode.values)
                ButtonSegment(value: m, label: Text(label(m))),
            ],
            selected: {settings.displayMode},
            onSelectionChanged: (s) => controller.setDisplayMode(s.first),
          ),
          const SizedBox(height: 16),
          Text(l10n.readingScale, style: theme.textTheme.bodyLarge),
          Slider(
            value: settings.textScale,
            min: kMinTextScale,
            max: kMaxTextScale,
            divisions: 10,
            label: '${(settings.textScale * 100).round()} %',
            onChanged: controller.setTextScale,
          ),
        ],
      ),
    );
  }
}

/// The reciter and speed used by default.
class AudioSection extends ConsumerWidget {
  const AudioSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(audioSettingsProvider);
    final controller = ref.read(audioSettingsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: settings.reciterId,
            decoration: InputDecoration(labelText: l10n.audioReciter),
            items: [
              for (final r in kReciters)
                DropdownMenuItem(value: r.id, child: Text(r.name)),
            ],
            onChanged: (id) {
              if (id != null) controller.setReciter(id);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<double>(
            initialValue: settings.speed,
            decoration: InputDecoration(labelText: l10n.audioSpeed),
            items: [
              for (final s in kPlaybackSpeeds)
                DropdownMenuItem(value: s, child: Text('${s}x')),
            ],
            onChanged: (s) {
              if (s != null) controller.setSpeed(s);
            },
          ),
        ],
      ),
    );
  }
}
