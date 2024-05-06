import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

class BadSwitch extends StatefulWidget {
  /// width of the switch
  final double width;

  /// height of the switch
  final double height;

  /// whether the switch is active initially
  final bool initialActive;

  /// callback when the state of the switch is changed
  final ValueChanged<bool> onActiveChanged;

  /// color of the handle when inactive
  final Color handleColor;

  /// color of the handle when active
  final Color handleColorActive;

  /// color of the track when inactive
  final Color trackColor;

  /// color of the track when active
  final Color trackColorActive;

  final double _ro;
  final double _ri;

  const BadSwitch({
    super.key,
    required this.width,
    required this.height,
    this.initialActive = false,
    required this.onActiveChanged,
    this.handleColor = Colors.white,
    this.handleColorActive = Colors.white,
    this.trackColor = Colors.grey,
    this.trackColorActive = Colors.blue,
  })  : assert(width > 10 && height > 10, 'size must be greater than 10x10'),
        assert(width > height, 'width must be greater than height'),
        _ro = height / 2,
        _ri = height / 2 - 2;

  @override
  State<BadSwitch> createState() => _BadSwitchState();
}

class _BadSwitchState extends State<BadSwitch> {
  bool active = false;

  void toggle() {
    setState(() {
      active = !active;
    });
    widget.onActiveChanged(active);
  }

  @override
  Widget build(BuildContext context) {
    final inner = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: active ? widget.trackColorActive : widget.trackColor,
        borderRadius: BorderRadius.circular(widget._ro),
      ),
      alignment: active ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: widget.height - 4,
        height: widget.height - 4,
        decoration: BoxDecoration(
          color: active ? widget.handleColorActive : widget.handleColor,
          borderRadius: BorderRadius.circular(widget._ri),
        ),
      ),
    );

    return BadClickable(onClick: toggle, child: inner);
  }
}
