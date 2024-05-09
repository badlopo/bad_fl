import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

class BadSwitch extends StatelessWidget {
  /// whether the switch is active
  final bool active;

  /// callback when the switch is tapped
  final VoidCallback onTap;

  /// width of the switch
  final double width;

  /// height of the switch
  final double height;

  /// gap between the track and the handle, in [0, height/2)
  final double gap;

  final Color handleColor;
  final Color handleColorActive;
  final Color trackColor;
  final Color trackColorActive;

  const BadSwitch({
    super.key,
    required this.active,
    required this.onTap,
    required this.width,
    required this.height,
    this.gap = 1,
    this.handleColor = Colors.white,
    this.handleColorActive = Colors.white,
    this.trackColor = Colors.grey,
    this.trackColorActive = Colors.blue,
  })  : assert(width > 10 && height > 10, 'size must be greater than 10x10'),
        assert(width > height, 'width must be greater than height'),
        assert(gap >= 0 && gap < height / 2, 'gap should in [0, height/2)');

  @override
  Widget build(BuildContext context) {
    final inner = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      padding: EdgeInsets.all(gap),
      decoration: BoxDecoration(
        color: active ? trackColorActive : trackColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: active ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: width - gap * 2,
        height: width - gap * 2,
        decoration: BoxDecoration(
          color: active ? handleColorActive : handleColor,
          borderRadius: BorderRadius.circular(height / 2 - gap),
        ),
      ),
    );

    return BadClickable(onClick: onTap, child: inner);
  }
}
