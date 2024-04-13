import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

typedef IconBuilder = Widget Function(bool checked);

class BadCheckBox extends StatelessWidget {
  /// size of the checkbox
  final double size;

  /// icon to be displayed inside the checkbox, can't be used with [iconBuilder]
  final Widget? icon;

  /// builder for the icon to be displayed inside the checkbox, can't be used with [icon]
  final IconBuilder? iconBuilder;

  /// size of the icon inside the checkbox, default to [size]
  final double iconSize;

  /// whether the checkbox is rounded
  final bool rounded;

  /// whether the checkbox is checked, this controls the state of the checkbox
  final bool checked;

  /// color of the checkbox when checked, default to null
  final Color? checkedColor;

  /// border when checked, default to null
  final Border? checkedBorder;

  /// callback when the checkbox is tapped
  final VoidCallback onTap;

  /// icon to be displayed inside the checkbox
  Widget get _innerIcon => icon ?? iconBuilder!(checked);

  // const BadCheckBox({
  //   super.key,
  //   required this.size,
  //   this.icon,
  //   this.iconBuilder,
  //   double? iconSize,
  //   this.rounded = true,
  //   required this.checked,
  //   this.checkedColor,
  //   this.checkedBorder,
  //   required this.onTap,
  // })  : iconSize = iconSize ?? size,
  //       assert(icon != null || iconBuilder != null,
  //           'icon or iconBuilder must be provided'),
  //       assert(icon == null || iconBuilder == null,
  //           'icon and iconBuilder can\'t be used together');

  const BadCheckBox.icon({
    super.key,
    required this.size,
    this.icon,
    double? iconSize,
    this.rounded = true,
    required this.checked,
    this.checkedColor,
    this.checkedBorder,
    required this.onTap,
  })  : iconSize = iconSize ?? size,
        iconBuilder = null;

  const BadCheckBox.iconBuilder({
    super.key,
    required this.size,
    required this.iconBuilder,
    double? iconSize,
    this.rounded = true,
    required this.checked,
    this.checkedColor,
    this.checkedBorder,
    required this.onTap,
  })  : iconSize = iconSize ?? size,
        icon = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Clickable(
          onClick: onTap,
          child: Container(
            width: size,
            height: size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: checked ? checkedColor : null,
              border: Border.all(color: Colors.white, width: 1),
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
