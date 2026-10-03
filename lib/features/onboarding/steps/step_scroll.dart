import 'package:flutter/material.dart';

/// Gives an Onboarding step room to scroll when its content is taller than
/// the screen — a small phone, or the text enlarged in the phone's settings
/// — and keeps it centered when it is not.
class StepScroll extends StatelessWidget {
  const StepScroll({super.key, required this.child, this.center = true});

  final Widget child;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: center ? Center(child: child) : child,
        ),
      ),
    );
  }
}
