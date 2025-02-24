import 'package:flutter/material.dart';

/// A combination of [Container] and [GestureDetector]
/// that provides a facade configuration for a button.
class BadButton extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Border? border;

  /// Default to `0`.
  final double borderRadius;
  final Color? fill;
  final void Function() onPressed;

  final Widget child;

  const BadButton({
    super.key,
    this.width,
    required this.height,
    this.margin,
    this.padding,
    this.constraints,
    this.border,
    this.borderRadius = 0,
    this.fill,
    required this.onPressed,
    required this.child,
  });

  /// In most case, child will be a [Row] contains two widget with a gap. (e.g. `Prefix + Text`, `Text + Suffix`)
  BadButton.two({
    super.key,
    this.width,
    required this.height,
    this.margin,
    this.padding,
    this.constraints,
    this.border,
    this.borderRadius = 0,
    this.fill,
    required this.onPressed,
    required Widget left,
    required Widget right,
    double gap = 0.0,
  }) : child = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [left, if (gap != 0) SizedBox(width: gap), right],
  );

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius:
        borderRadius == 0 ? null : BorderRadius.circular(borderRadius),
        border: border,
        color: fill,
      ),
      alignment: Alignment.center,
      child: child,
    );

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: inner,
    );
  }
}

class BadButtonAsync extends StatefulWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Border? border;

  /// Default to `0`.
  final double borderRadius;
  final Color? fill;
  final Future<void> Function() onPressed;

  /// Child widget to show when `onPressed` is executing.
  final Widget pending;

  /// Child widget to show when the button in `idle` state.
  final Widget idle;

  const BadButtonAsync({
    super.key,
    this.width,
    required this.height,
    this.margin,
    this.padding,
    this.constraints,
    this.border,
    this.borderRadius = 0,
    this.fill,
    required this.onPressed,
    required this.pending,
    required this.idle,
  });

  @override
  State<BadButtonAsync> createState() => _ButtonAsyncState();
}

class _ButtonAsyncState extends State<BadButtonAsync> {
  BorderRadius? get borderRadius =>
      widget.borderRadius == 0
          ? null
          : BorderRadius.circular(widget.borderRadius);

  bool pending = false;

  Future<void> onPressDelegate() async {
    if (pending) return;

    setState(() {
      pending = true;
    });
    await widget.onPressed();
    setState(() {
      pending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding,
      constraints: widget.constraints,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: widget.border,
        color: widget.fill,
      ),
      alignment: Alignment.center,
      child: pending ? widget.pending : widget.idle,
    );

    return GestureDetector(
      onTap: onPressDelegate,
      behavior: HitTestBehavior.opaque,
      child: inner,
    );
  }
}
