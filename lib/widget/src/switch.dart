import 'package:bad_fl/widget/src/clickable.dart';
import 'package:flutter/material.dart';

/// This widget is designed as controlled widget.
class BadSwitch extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final double width;
  final double height;
  final EdgeInsets padding;
  final Color handleColor;
  final Color activeHandleColor;
  final Color trackColor;
  final Color activeTrackColor;

  double get handleSize {
    return height - padding.vertical;
  }

  const BadSwitch({
    super.key,
    required this.active,
    required this.onTap,
    this.width = 40,
    this.height = 24,
    this.padding = const EdgeInsets.all(2),
    this.handleColor = Colors.white,
    this.activeHandleColor = Colors.white,
    this.trackColor = Colors.grey,
    this.activeTrackColor = Colors.blue,
  }) : assert(width > height, 'Think twice!');

  @override
  Widget build(BuildContext context) {
    final inner = UnconstrainedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: active ? activeTrackColor : trackColor,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        alignment: active ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: active ? activeHandleColor : handleColor,
          ),
        ),
      ),
    );

    return BadClickable(onClick: onTap, child: inner);
  }
}
