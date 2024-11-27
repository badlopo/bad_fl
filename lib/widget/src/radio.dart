import 'package:bad_fl/ext/src/iterable.dart';
import 'package:bad_fl/widget/src/clickable.dart';
import 'package:flutter/material.dart';

/// Radio widget with custom builder for items.
class BadRadio<Value> extends StatelessWidget {
  final int activeIndex;

  /// Callback when an non-active item is tapped (with its index).
  final ValueChanged<int> onTap;

  /// Values for each item.
  final Iterable<Value> values;

  /// Widget builder for each item.
  final Widget Function(Value value) builder;

  /// Widget builder for the active item. Use [builder] if not provided.
  final Widget Function(Value value)? activeBuilder;

  final double? width;
  final double height;

  /// Default to `EdgeInsets.zero`.
  final EdgeInsets padding;

  /// Note: the `borderRadius` field will be ignored.
  final BoxDecoration? decoration;

  /// Border radius of the radio group.
  ///
  /// Default to `0.0`.
  final double borderRadius;

  /// Note: the `borderRadius` field will be ignored.
  final BoxDecoration? activeDecoration;

  /// Border radius of the active item.
  /// If `null`, `borderRadius - padding.vertical / 2` will be used.
  ///
  /// Default to `null`.
  final double? activeBorderRadius;

  BorderRadius? get _activeBorderRadius {
    if (activeBorderRadius != null) {
      return BorderRadius.circular(activeBorderRadius!);
    }

    final r = borderRadius - padding.vertical / 2;
    return r > 0 ? BorderRadius.circular(r) : null;
  }

  void _onTap(int to) {
    if (to == activeIndex) return;

    onTap(to);
  }

  const BadRadio({
    super.key,
    required this.activeIndex,
    required this.onTap,
    required this.values,
    required this.builder,
    this.activeBuilder,
    this.width,
    required this.height,
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.borderRadius = 0.0,
    this.activeDecoration,
    this.activeBorderRadius,
  }) : assert(values.length > 0, 'Think twice!');

  @override
  Widget build(BuildContext context) {
    final count = values.length;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration?.copyWith(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(builder: (_, constraints) {
        final width = constraints.maxWidth / count;
        final build = activeBuilder ?? builder;

        return Stack(
          children: [
            Row(
              children: [
                for (final (index, value) in values.enumerate)
                  Expanded(
                    flex: 1,
                    child: BadClickable(
                      onClick: () => _onTap(index),
                      child: Center(child: builder(value)),
                    ),
                  ),
              ],
            ),
            AnimatedPositioned(
              width: width,
              left: width * activeIndex,
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                child: Container(
                  height: constraints.maxHeight,
                  decoration: activeDecoration?.copyWith(
                    borderRadius: _activeBorderRadius,
                  ),
                  alignment: Alignment.center,
                  child: build(values.elementAt(activeIndex)),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
