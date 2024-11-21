import 'package:flutter/material.dart';

/// A wrapper widget that makes its child clickable.
class BadClickable extends StatelessWidget {
  final Widget child;
  final VoidCallback onClick;

  const BadClickable({super.key, required this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
