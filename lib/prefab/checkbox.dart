import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

typedef IconBuilder = Widget Function(bool checked);

class BadCheckBox extends StatefulWidget {
  /// size of the checkbox
  final double size;

  /// icon to be displayed inside the checkbox, can't be used with [iconBuilder]
  final Widget? icon;

  /// builder for the icon to be displayed inside the checkbox, can't be used with [icon]
  final IconBuilder? iconBuilder;

  /// size of the icon inside the checkbox, default to [size]
  final double iconSize;

  /// border of the checkbox
  final Border border;

  /// whether the checkbox is rounded
  final bool rounded;

  /// whether the checkbox is checked initially, default to false
  final bool initialChecked;

  /// color of the checkbox when checked, default to null
  final Color? checkedColor;

  /// callback when the state of the checkbox is changed
  final ValueChanged<bool> onCheckedChanged;

  const BadCheckBox.icon({
    super.key,
    required this.size,
    required this.icon,
    double? iconSize,
    required this.border,
    this.rounded = true,
    this.initialChecked = false,
    this.checkedColor,
    required this.onCheckedChanged,
  })  : iconSize = iconSize ?? size,
        iconBuilder = null,
        assert(icon != null, 'icon must be provided');

  const BadCheckBox.iconBuilder({
    super.key,
    required this.size,
    required this.iconBuilder,
    double? iconSize,
    required this.border,
    this.rounded = true,
    this.initialChecked = false,
    this.checkedColor,
    required this.onCheckedChanged,
  })  : iconSize = iconSize ?? size,
        icon = null,
        assert(iconBuilder != null, 'iconBuilder must be provided');

  @override
  State<BadCheckBox> createState() => _BadCheckBoxState();
}

class _BadCheckBoxState extends State<BadCheckBox> {
  bool checked = false;

  /// icon to be displayed inside the checkbox
  Widget get _innerIcon => widget.icon ?? widget.iconBuilder!(checked);

  void toggle() {
    setState(() {
      checked = !checked;
    });
    widget.onCheckedChanged(checked);
  }

  @override
  void initState() {
    super.initState();

    checked = widget.initialChecked;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: BadClickable(
          onClick: toggle,
          child: Container(
            width: widget.size,
            height: widget.size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: checked ? widget.checkedColor : null,
              border: widget.border,
              borderRadius: widget.rounded
                  ? BorderRadius.circular(widget.size / 2)
                  : null,
            ),
            child: checked
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: widget.iconSize,
                      maxHeight: widget.iconSize,
                    ),
                    child: Center(child: _innerIcon),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
