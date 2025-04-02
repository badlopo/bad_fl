import 'dart:async';

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
  }) : assert(width > height);

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

class BadSwitchAsync extends StatefulWidget {
  /// Initial state of switch.
  final bool active;

  /// Widget to display inside handle when processing.
  final Widget loadingWidget;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback and
  /// - update state if it returns truthy.
  /// - do nothing if it returns falsy.
  final FutureOr<bool> Function(bool to) onTap;
  final double width;
  final double height;
  final EdgeInsets padding;
  final Color handleColor;
  final Color activeHandleColor;
  final Color trackColor;
  final Color activeTrackColor;

  const BadSwitchAsync({
    super.key,
    required this.active,
    required this.loadingWidget,
    required this.onTap,
    this.width = 40,
    this.height = 24,
    this.padding = const EdgeInsets.all(2),
    this.handleColor = Colors.white,
    this.activeHandleColor = Colors.white,
    this.trackColor = Colors.grey,
    this.activeTrackColor = Colors.blue,
  }) : assert(width > height);

  @override
  State<BadSwitchAsync> createState() => _SwitchAsyncState();
}

class _SwitchAsyncState extends State<BadSwitchAsync> {
  late bool active;
  late double handleSize;

  bool running = false;

  Future<void> handleTap() async {
    if (running) return;

    setState(() {
      running = true;
    });

    final update = await widget.onTap(!active);

    setState(() {
      running = false;
      if (update) active = !active;
    });
  }

  @override
  void initState() {
    super.initState();

    active = widget.active;
    handleSize = widget.height - widget.padding.vertical;
  }

  @override
  void didUpdateWidget(covariant BadSwitchAsync oldWidget) {
    super.didUpdateWidget(oldWidget);

    active = widget.active;
    handleSize = widget.height - widget.padding.vertical;
  }

  @override
  Widget build(BuildContext context) {
    final inner = UnconstrainedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: active ? widget.activeTrackColor : widget.trackColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        alignment: active ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: active ? widget.activeHandleColor : widget.handleColor,
          ),
          alignment: Alignment.center,
          child: running ? widget.loadingWidget : null,
        ),
      ),
    );

    return BadClickable(onClick: handleTap, child: inner);
  }
}
