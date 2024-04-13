import 'package:flutter/material.dart';

/// a wrapper to add click event to a widget
class Clickable extends StatelessWidget {
  final Widget child;
  final VoidCallback onClick;

  const Clickable({
    super.key,
    required this.child,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
