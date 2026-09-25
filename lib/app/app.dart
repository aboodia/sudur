import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings/theme_settings.dart';
import 'router.dart';
import 'theme.dart';

class WirdApp extends ConsumerWidget {
  const WirdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(themeVariantProvider);

    return MaterialApp.router(
      title: 'Wird',
      debugShowCheckedModeBanner: false,
      theme: WirdTheme.light(variant),
      darkTheme: WirdTheme.dark(variant),
      routerConfig: appRouter,
    );
  }
}
