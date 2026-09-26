import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/gamification/memorizer_badge_icon.dart';
import '../../../core/gamification/memorizer_profile.dart';
import '../onboarding_draft.dart';

/// The "profils & badges" step — see `design/Les 8 profils et badges@1x.png`.
/// Shows which of the 8 tiers the number of memorized sourates unlocks,
/// right after the selection step.
class DerivedProfileStep extends ConsumerWidget {
  const DerivedProfileStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final draft = ref.watch(onboardingDraftProvider);
    final badge = memorizerBadgeForCount(draft.memorizedSurahs.length);
    final info = badge.info;

    final foreground = info.isDark ? Colors.white : theme.colorScheme.onSurface;
    final subForeground =
        info.isDark ? Colors.white.withValues(alpha: 0.75) : theme.colorScheme.onSurfaceVariant;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MemorizerBadgeIcon(color: info.color, icon: info.icon, size: 72),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: info.color.withValues(alpha: info.isDark ? 0.24 : 0.14),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            info.rangeLabel,
            style: theme.textTheme.labelMedium?.copyWith(color: info.isDark ? info.color : null),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          info.arabicTitle,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Amiri', fontSize: 40, color: foreground),
        ),
        const SizedBox(height: 12),
        Text(
          info.frenchName,
          style: theme.textTheme.headlineSmall?.copyWith(color: foreground),
          textAlign: TextAlign.center,
        ),
        Text(
          info.transliteration,
          style: theme.textTheme.bodyMedium?.copyWith(color: subForeground, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          info.description,
          style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
          textAlign: TextAlign.center,
        ),
      ],
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: info.isDark
            ? Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2A2E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}
