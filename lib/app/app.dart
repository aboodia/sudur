import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class WirdApp extends StatelessWidget {
  const WirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wird',
      debugShowCheckedModeBanner: false,
      theme: WirdTheme.light(),
      darkTheme: WirdTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
