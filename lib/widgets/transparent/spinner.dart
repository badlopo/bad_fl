import 'package:flutter/material.dart';

/// A wrapper widget that provides a spinning animation to its child.
class BadSpinner extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const BadSpinner({
    super.key,
    this.duration = const Duration(seconds: 1),
    required this.child,
  });

  @override
  State<BadSpinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<BadSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant BadSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.stop(canceled: false);
    _controller.duration = widget.duration;
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: _controller, child: widget.child);
  }
}
