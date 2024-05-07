import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

typedef IconBuilder = Widget Function(bool checked);

/// Note: this is a controlled checkbox, you need to manage the state of the checkbox yourself.
class BadCheckBox extends StatelessWidget {
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

  /// color of the checkbox when checked, default to null
  final Color? checkedColor;

  /// whether the checkbox is checked initially, default to false
  final bool checked;

  /// callback when the state of the checkbox is changed
  final VoidCallback onTap;

  const BadCheckBox.icon({
    super.key,
    required this.size,
    required this.icon,
    double? iconSize,
    required this.border,
    this.rounded = true,
    this.checkedColor,
    required this.checked,
    required this.onTap,
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
    this.checkedColor,
    required this.checked,
    required this.onTap,
  })  : iconSize = iconSize ?? size,
        icon = null,
        assert(iconBuilder != null, 'iconBuilder must be provided');

  /// icon to be displayed inside the checkbox
  Widget get _innerIcon => icon ?? iconBuilder!(checked);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: BadClickable(
          onClick: onTap,
          child: Container(
            width: size,
            height: size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: checked ? checkedColor : null,
              border: border,
              borderRadius: rounded ? BorderRadius.circular(size / 2) : null,
            ),
            child: checked
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: iconSize,
                      maxHeight: iconSize,
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
