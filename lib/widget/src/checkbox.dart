import 'package:bad_fl/widget/src/clickable.dart';
import 'package:flutter/material.dart';

/// This widget is designed as controlled widget.
class BadCheckbox extends StatelessWidget {
  final bool checked;

  final double size;

  /// Icon to be displayed inside the checkbox when checked.
  final Widget checkedIcon;

  final Border? border;

  /// Default to `0.0`.
  final double borderRadius;

  BorderRadius? get _borderRadius =>
      borderRadius == 0 ? null : BorderRadius.circular(borderRadius);

  /// Color of the checkbox.
  final Color? fill;

  /// Color of the checkbox when checked. Use [fill] if not provided.
  final Color? checkedFill;

  final VoidCallback onTap;

  const BadCheckbox({
    super.key,
    required this.checked,
    required this.size,
    required this.checkedIcon,
    this.border,
    this.borderRadius = 0.0,
    this.fill,
    this.checkedFill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // wrapped in UnconstrainedBox to prevent the checkbox from being stretched (e.g. in a ListView)
    return UnconstrainedBox(
      child: BadClickable(
        onClick: onTap,
        child: Container(
          width: size,
          height: size,
          constraints: BoxConstraints(maxWidth: size, maxHeight: size),
          decoration: BoxDecoration(
            color: checked ? (checkedFill ?? fill) : fill,
            border: border,
            borderRadius: _borderRadius,
          ),
          alignment: Alignment.center,
          child: checked ? checkedIcon : null,
        ),
      ),
    );
  }
}
