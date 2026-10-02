import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/audio_playback_controller.dart';
import 'screens/chain_screen.dart';
import 'screens/completed_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/mask_screen.dart';
import 'screens/recite_screen.dart';
import 'screens/repeat_screen.dart';
import 'session_controller.dart';

/// Single entry point for the 5-step guided memorization parcours — reads
/// (or starts) today's passage on open and renders whichever step/screen
/// the session is currently on, the same "one screen, internal state
/// machine" pattern as [OnboardingFlow].
class MemorizationFlowScreen extends ConsumerStatefulWidget {
  const MemorizationFlowScreen({super.key});

  @override
  ConsumerState<MemorizationFlowScreen> createState() =>
      _MemorizationFlowScreenState();
}

class _MemorizationFlowScreenState
    extends ConsumerState<MemorizationFlowScreen> {
  late final AudioPlaybackController _audio;

  @override
  void initState() {
    super.initState();
    _audio = ref.read(audioPlaybackProvider.notifier);
    Future.microtask(
      () => ref.read(guidedSessionProvider.notifier).startOrResume(),
    );
  }

  @override
  void dispose() {
    // Deferred: a provider can't be modified while the tree is unmounting.
    Future.microtask(_audio.endGuidedListening);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(guidedSessionProvider);

    if (!session.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.isFinished) {
      final passage = session.passage;
      if (passage == null) {
        // Le Coran entier est déjà mémorisé — rien à proposer aujourd'hui.
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Mabrouk, il n\'y a plus de nouveau passage à mémoriser !',
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/accueil'),
                    child: const Text('Retour à l\'accueil'),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      final watched = session.chainStatuses.values
          .where((s) => s == ChainAyahStatus.hesitant)
          .length;
      return CompletedScreen(
        surahNumber: passage.surahNumber,
        ayahStart: passage.ayahStart,
        ayahEnd: passage.ayahEnd,
        startedAt: passage.createdAt,
        watchedAyahCount: watched,
      );
    }

    final passage = session.passage!;
    final ayah = session.currentAyah ?? passage.ayahStart;

    switch (session.stepIndex) {
      case stepDiscover:
        return DiscoverScreen(
          key: const ValueKey('discover'),
          passage: passage,
        );
      case stepRepeat:
        return RepeatScreen(
          key: ValueKey('repeat-$ayah'),
          passage: passage,
          ayahNumber: ayah,
        );
      case stepMask:
        return MaskScreen(
          key: ValueKey('mask-$ayah'),
          passage: passage,
          ayahNumber: ayah,
        );
      case stepRecite:
        return ReciteScreen(
          key: ValueKey('recite-$ayah'),
          passage: passage,
          ayahNumber: ayah,
        );
      case stepChain:
        return ChainScreen(key: const ValueKey('chain'), passage: passage);
      default:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
