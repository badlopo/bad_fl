import 'package:flutter/material.dart';

/// a wrapper to add click event to a widget
class BadClickable extends StatelessWidget {
  final Widget child;
  final VoidCallback onClick;

  const BadClickable({
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
