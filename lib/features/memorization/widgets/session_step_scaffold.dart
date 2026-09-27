import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// The shared header of the 5-step guided memorization flow (Découvrir →
/// Répéter → Masquer → Réciter → Enchaîner) : a 5-segment progress bar,
/// "Étape N sur 5 · `<nom>`", a back/quit control, and the step's own body +
/// bottom action bar.
///
/// The leading control follows the mockups exactly: on the first step
/// there's no previous step to return to within the passage, so it's a
/// "quitter" (✕, saves progress then leaves); on later steps it's a plain
/// back arrow to the previous step.
class SessionStepScaffold extends StatelessWidget {
  const SessionStepScaffold({
    super.key,
    required this.stepIndex,
    required this.stepLabel,
    required this.headerLabel,
    required this.body,
    required this.bottomBar,
    required this.onQuit,
    this.onBack,
    this.trailing,
  });

  static const stepCount = 5;
  static const stepNames = [
    'Découvrir',
    'Répéter',
    'Masquer',
    'Réciter',
    'Enchaîner',
  ];

  /// 0-4.
  final int stepIndex;

  /// Usually [stepNames][stepIndex] — kept as its own parameter so a screen
  /// can override it if needed (e.g. localization later).
  final String stepLabel;

  /// e.g. "AL-MULK · 1-5".
  final String headerLabel;

  final Widget body;
  final Widget bottomBar;

  /// Saves progress and leaves the parcours — only reachable from the
  /// first step (later steps go back instead, see [onBack]).
  final VoidCallback onQuit;

  /// Goes back to the previous step — null on the first step, where
  /// [onQuit] is shown instead.
  final VoidCallback? onBack;

  /// Optional top-right control (e.g. per-step options) — omitted entirely
  /// when null rather than showing an inert placeholder icon.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  if (onBack != null)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: l10n.sessionBackTooltip,
                      onPressed: onBack,
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l10n.sessionQuitTooltip,
                      onPressed: onQuit,
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          headerLabel,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          l10n.stepOfTotal(stepIndex + 1, stepCount, stepLabel),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null)
                    trailing!
                  else
                    const SizedBox(width: 48, height: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _StepProgressBar(stepIndex: stepIndex),
            ),
            const SizedBox(height: 16),
            Expanded(child: body),
            Padding(padding: const EdgeInsets.all(16), child: bottomBar),
          ],
        ),
      ),
    );
  }
}

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        for (var i = 0; i < SessionStepScaffold.stepCount; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i <= stepIndex
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
