import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/audio/audio_playback_controller.dart';
import '../l10n/app_localizations.dart';
import 'app.dart';
import 'router.dart';

/// Tells the user when an ayah cannot be played — typically no connection
/// for audio that was never downloaded — instead of leaving the play button
/// silently doing nothing, and points to the offline content.
class PlaybackErrorHost extends ConsumerWidget {
  const PlaybackErrorHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(audioPlaybackProvider.select((s) => s.playbackFailures), (
      previous,
      next,
    ) {
      if (next <= (previous ?? 0)) return;
      final messenger = appMessengerKey.currentState;
      if (messenger == null) return;
      final l10n = lookupAppLocalizations(const Locale('fr'));
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.playbackOffline),
            duration: const Duration(seconds: 5),
            // Above the bottom bar: the session screens keep their main
            // button there, which a message on the bottom edge would hide.
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 170),
            action: SnackBarAction(
              label: l10n.playbackOfflineAction,
              onPressed: () => appRouter.push('/hors-ligne'),
            ),
          ),
        );
    });
    return child;
  }
}
