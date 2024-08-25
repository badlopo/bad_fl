import 'package:flutter/material.dart';

import 'clickable.dart';

class BadCheckbox extends StatelessWidget {
  /// size of the checkbox
  final double size;

  /// icon to be displayed inside the checkbox when checked, can't be used with [iconBuilder]
  final Widget? icon;

  /// builder for the icon to be displayed inside the checkbox, return `null` to hide the icon, can't be used with [icon]
  final Widget? Function(bool checked)? iconBuilder;

  /// size of the icon inside the checkbox
  ///
  /// Default to [size]
  final double iconSize;

  /// border of the checkbox
  final Border? border;

  /// whether the checkbox is rounded
  final bool rounded;

  /// color of the checkbox when unchecked
  final Color? fill;

  /// color of the checkbox when checked
  ///
  /// Default to [fill]
  final Color? fillChecked;

  /// whether the checkbox is checked
  final bool checked;

  /// callback when the checkbox is tapped
  final VoidCallback onTap;

  /// whether to use [icon] or [iconBuilder]
  final bool _useBuilder;

  const BadCheckbox.icon({
    super.key,
    required this.size,
    required this.icon,
    double? iconSize,
    this.border,
    this.rounded = true,
    this.fill,
    Color? fillChecked,
    required this.checked,
    required this.onTap,
  })  : iconSize = iconSize ?? size,
        iconBuilder = null,
        fillChecked = fillChecked ?? fill,
        _useBuilder = false,
        assert(icon != null, 'icon must be provided');

  const BadCheckbox.iconBuilder({
    super.key,
    required this.size,
    required this.iconBuilder,
    double? iconSize,
    this.border,
    this.rounded = true,
    this.fill,
    Color? fillChecked,
    required this.checked,
    required this.onTap,
  })  : iconSize = iconSize ?? size,
        icon = null,
        fillChecked = fillChecked ?? fill,
        _useBuilder = true,
        assert(iconBuilder != null, 'iconBuilder must be provided');

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
              color: checked ? fillChecked : fill,
              border: border,
              borderRadius: rounded ? BorderRadius.circular(size / 2) : null,
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: iconSize,
              height: iconSize,
              child: _useBuilder
                  ? iconBuilder!(checked)
                  : checked
                      ? icon
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
