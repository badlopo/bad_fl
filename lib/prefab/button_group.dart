import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

class BadButtonGroup extends StatefulWidget {
  /// initial index of the button group
  final int initialIndex;

  /// callback when the index changes
  final ValueChanged<int> onChanged;

  /// width of the button group
  final double? width;

  /// height of the button group
  final double height;

  /// space between content and outside of the button group
  ///
  /// Default to `EdgeInsets.all(4)`
  final EdgeInsets padding;

  /// border of the button group
  final BoxBorder? border;

  /// border radius of the button group
  final double borderRadius;

  /// background color of the button group
  final Color? fill;

  /// background gradient of the button group
  ///
  /// Note: If this is specified, [fill] has no effect.
  final Gradient? gradient;

  /// background color of the active button
  final Color? activeFill;

  /// background gradient of the active button
  ///
  /// Note: If this is specified, [activeFill] has no effect.
  final Gradient? activeGradient;

  /// button group children
  final List<Widget> children;

  const BadButtonGroup({
    super.key,
    this.initialIndex = 0,
    required this.onChanged,
    this.width,
    required this.height,
    this.padding = const EdgeInsets.all(4),
    this.border,
    this.borderRadius = 0.0,
    this.fill,
    this.gradient,
    this.activeFill,
    this.activeGradient,
    required this.children,
  })  : assert(children.length >= 2, 'requires at least 2 buttons'),
        assert(
          initialIndex >= 0 && initialIndex < children.length,
          'initial index out of range',
        );

  @override
  State<BadButtonGroup> createState() => _BadButtonGroupState();
}

class _BadButtonGroupState extends State<BadButtonGroup> {
  late final int count;

  late final double innerH;
  late final BorderRadius? innerRadius;

  int activeIndex = 0;

  void handleTap(int to) {
    if (to == activeIndex) return;

    setState(() {
      activeIndex = to;
    });
    widget.onChanged(to);
  }

  @override
  void initState() {
    super.initState();

    count = widget.children.length;

    innerH = widget.height - widget.padding.vertical;
    var innerR = widget.borderRadius - widget.padding.horizontal / 2;
    innerRadius = innerR > 0 ? BorderRadius.circular(innerR) : null;

    activeIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.fill,
        gradient: widget.gradient,
        border: widget.border,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
        final double partW = constraints.maxWidth / count;
        final double offset = partW * activeIndex;

        return Stack(
          children: [
            Row(
              children: [
                for (int i = 0; i < count; i++)
                  Expanded(
                    flex: 1,
                    child: BadClickable(
                      onClick: () => handleTap(i),
                      child: Center(child: widget.children[i]),
                    ),
                  ),
              ],
            ),
            AnimatedPositioned(
              left: offset,
              width: partW,
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                child: Container(
                  height: innerH,
                  decoration: BoxDecoration(
                    borderRadius: innerRadius,
                    color: widget.activeFill,
                    gradient: widget.activeGradient,
                  ),
                  alignment: Alignment.center,
                  child: widget.children[activeIndex],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
