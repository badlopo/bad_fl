import 'package:flutter/material.dart';

import 'clickable.dart';

class BadButton extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Border? border;
  final double borderRadius;
  final Color? fill;
  final Widget child;
  final VoidCallback onPressed;

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
    required this.child,
    required this.onPressed,
  });

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

    return BadClickable(onClick: onPressed, child: inner);
  }
}
