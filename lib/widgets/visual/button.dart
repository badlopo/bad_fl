import 'dart:async';

import 'package:flutter/material.dart';

/// A combination of [Container] and [GestureDetector]
/// that provides a facade configuration for a button.
class BadButton extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Border? border;
  final double borderRadius;
  final Color? fill;
  final Alignment? alignment;
  final FutureOr<void> Function() onPressed;

  final Widget child;

  /// Widget to show when `onPressed` is executing.
  /// If not provided, the button will not show any loading state.
  final Widget? loadingWidget;

  const BadButton({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.constraints,
    this.border,
    this.borderRadius = 0,
    this.fill,
    this.alignment = Alignment.center,
    required this.onPressed,
    this.loadingWidget,
    required this.child,
  });

  BadButton.icon({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.constraints,
    this.border,
    this.borderRadius = 0,
    this.fill,
    this.alignment = Alignment.center,
    required this.onPressed,
    this.loadingWidget,
    required Widget icon,
    required Widget label,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    double gap = 0.0,
  }) : child = Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon, if (gap != 0) SizedBox(width: gap), label],
        );

  @override
  State<BadButton> createState() => _ButtonState();
}

class _ButtonState extends State<BadButton> {
  BorderRadius? get borderRadius => widget.borderRadius == 0
      ? null
      : BorderRadius.circular(widget.borderRadius);

  bool running = false;

  Future<void> _onPress() async {
    if (running) return;

    setState(() {
      running = true;
    });
    await widget.onPressed();
    setState(() {
      running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget inner = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      constraints: widget.constraints,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: widget.border,
        color: widget.fill,
      ),
      alignment: widget.alignment,
      child: running ? (widget.loadingWidget ?? widget.child) : widget.child,
    );

    inner = GestureDetector(
      onTap: _onPress,
      behavior: HitTestBehavior.opaque,
      child: inner,
    );

    // wrap with Padding outside GestureDetector to ensure margin
    // is applied correctly (will not interfere with tap detection)
    if (widget.margin != null) {
      inner = Padding(padding: widget.margin!, child: inner);
    }

    return inner;
  }
}
