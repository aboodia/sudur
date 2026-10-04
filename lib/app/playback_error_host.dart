import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/audio/audio_playback_controller.dart';
import '../l10n/app_localizations.dart';
import 'app.dart';
import 'router.dart';

/// Tells the user when an ayah cannot be played — typically no connection
/// for audio that was never downloaded — instead of leaving the play button
/// silently doing nothing, and points to the offline content.
class PlaybackErrorHost extends ConsumerStatefulWidget {
  const PlaybackErrorHost({super.key, required this.child});

  final Widget child;

  /// Failures closer together than this are told once: stepping through a
  /// passage offline fails at every verse, and repeating the message each
  /// time only gets in the way.
  static const quietPeriod = Duration(seconds: 20);

  @override
  ConsumerState<PlaybackErrorHost> createState() => _PlaybackErrorHostState();
}

class _PlaybackErrorHostState extends ConsumerState<PlaybackErrorHost> {
  DateTime? _lastShown;

  @override
  Widget build(BuildContext context) {
    ref.listen(audioPlaybackProvider.select((s) => s.playbackFailures), (
      previous,
      next,
    ) {
      if (next <= (previous ?? 0)) return;
      final messenger = appMessengerKey.currentState;
      if (messenger == null) return;
      final now = DateTime.now();
      final last = _lastShown;
      if (last != null &&
          now.difference(last) < PlaybackErrorHost.quietPeriod) {
        return;
      }
      _lastShown = now;
      final l10n = lookupAppLocalizations(const Locale('fr'));
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.playbackOffline),
            duration: const Duration(seconds: 5),
            // A message with an action stays up until dismissed, by default.
            persist: false,
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
    return widget.child;
  }
}
