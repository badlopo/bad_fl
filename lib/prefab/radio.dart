import 'package:flutter/material.dart';

import 'clickable.dart';

class BadRadio<Item> extends StatelessWidget {
  /// index of the active item
  final int activeIndex;

  /// callback when the item is tapped (won't be called if the active item is tapped)
  final ValueChanged<int> onTap;

  /// width of the radio group
  final double? width;

  /// height of the radio group
  final double height;

  /// space between content and outside of the radio group
  ///
  /// Default to `EdgeInsets.all(4)`
  final EdgeInsets padding;

  /// border of the radio group
  final BoxBorder? border;

  /// border radius of the radio group
  final double borderRadius;

  /// background color of the radio group
  final Color? fill;

  /// background gradient of the radio group
  ///
  /// Note: [fill] will be ignored if this is specified.
  final Gradient? gradient;

  /// background color of the active item
  final Color? activeFill;

  /// background gradient of the active item
  ///
  /// Note: [activeFill] will be ignored if this is specified.
  final Gradient? activeGradient;

  /// values for each item
  final List<Item> values;

  /// builder for each item
  final Widget Function(Item value) childBuilder;

  /// builder for the active item, if not specified, [childBuilder] will be used
  final Widget Function(Item value)? activeChildBuilder;

  void handleTap(int to) {
    if (to == activeIndex) return;

    onTap(to);
  }

  final int _count;

  const BadRadio({
    super.key,
    required this.activeIndex,
    required this.onTap,
    this.width,
    required this.height,
    this.padding = const EdgeInsets.all(4),
    this.border,
    this.borderRadius = 0.0,
    this.fill,
    this.gradient,
    this.activeFill,
    this.activeGradient,
    required this.values,
    required this.childBuilder,
    this.activeChildBuilder,
  })  : assert(values.length >= 2, 'requires at least 2 items'),
        assert(activeIndex >= 0 && activeIndex < values.length, 'out of range'),
        _count = values.length;

  @override
  Widget build(BuildContext context) {
    final innerR = borderRadius - padding.horizontal / 2;
    final innerRadius = innerR > 0 ? BorderRadius.circular(innerR) : null;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        gradient: gradient,
        border: border,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        final double w = constraints.maxWidth / _count;
        final double h = constraints.maxHeight;
        final double offset = w * activeIndex;
        final builder = activeChildBuilder ?? childBuilder;

        return Stack(
          children: [
            Row(
              children: [
                for (int i = 0; i < _count; i++)
                  Expanded(
                    flex: 1,
                    child: BadClickable(
                      onClick: () => handleTap(i),
                      child: Center(
                        child: childBuilder(values[i]),
                      ),
                    ),
                  ),
              ],
            ),
            AnimatedPositioned(
              left: offset,
              width: w,
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                child: Container(
                  height: h,
                  decoration: BoxDecoration(
                    borderRadius: innerRadius,
                    color: activeFill,
                    gradient: activeGradient,
                  ),
                  alignment: Alignment.center,
                  child: builder(values[activeIndex]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
