import 'dart:async';

import 'package:bad_fl/widgets/transparent/clickable.dart';
import 'package:bad_fl/widgets/transparent/spinner.dart';
import 'package:flutter/material.dart';

class BadSwitch extends StatefulWidget {
  /// Initial state of switch.
  final bool initialActive;

  /// Called when the state of a switch is about to change.
  /// If the return value is true, the change is performed;
  /// otherwise the change is prevented.
  ///
  /// While it is executing, the component will show a loading
  /// state and ignore clicks until the execution is completed.
  final FutureOr<bool> Function(bool to) onWillChange;

  final double width;
  final double height;
  final double insets;

  final Color handleColor;
  final Color activeHandleColor;
  final Color trackColor;
  final Color activeTrackColor;

  /// The color of the spinner, set to null to follow the track color.
  final Color? spinnerColor;

  final double _handleSize;

  const BadSwitch({
    super.key,
    this.initialActive = false,
    required this.onWillChange,
    this.width = 56,
    this.height = 28,
    this.insets = 2,
    this.handleColor = Colors.white,
    this.activeHandleColor = Colors.white,
    this.trackColor = Colors.grey,
    this.activeTrackColor = Colors.green,
    this.spinnerColor,
  })  : assert(height > insets * 2),
        assert(width > height),
        _handleSize = height - insets * 2;

  @override
  State<BadSwitch> createState() => _SwitchState();
}

class _SwitchState extends State<BadSwitch> {
  late bool active;
  bool pending = false;

  Color get spinnerColor {
    return widget.spinnerColor ??
        (active ? widget.activeTrackColor : widget.trackColor);
  }

  void handleTap() async {
    if (pending) return;

    setState(() {
      pending = true;
    });

    final ok = await widget.onWillChange(!active);

    setState(() {
      pending = false;
      if (ok) active = !active;
    });
  }

  @override
  void initState() {
    super.initState();

    active = widget.initialActive;
  }

  @override
  Widget build(BuildContext context) {
    final inner = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(widget.insets),
      decoration: BoxDecoration(
        color: active ? widget.activeTrackColor : widget.trackColor,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      alignment: active ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: widget._handleSize,
        height: widget._handleSize,
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: active ? widget.activeHandleColor : widget.handleColor,
        ),
        alignment: Alignment.center,
        child: pending
            ? BadSpinner(
                child: Icon(
                  Icons.autorenew_rounded,
                  size: widget._handleSize,
                  color: spinnerColor,
                ),
              )
            : null,
      ),
    );

    return UnconstrainedBox(
      child: BadClickable(onClick: handleTap, child: inner),
    );
  }
}
