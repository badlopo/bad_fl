import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

enum BadExpandableState { empty, open, close }

class BadExpandable extends StatelessWidget {
  /// whether the panel is open
  final bool open;

  /// callback when the header is clicked
  final VoidCallback onToggle;

  /// callback when the animation is finished
  final VoidCallback? onEnd;

  /// gap between the header and the child
  ///
  /// Default to `0`
  final double gap;

  /// builder for the header widget
  final Widget Function(BadExpandableState state) headerBuilder;

  /// child widget to be displayed when the panel is open
  ///
  /// Note: if [child] is `null`, this widget will be treated as an empty panel.
  final Widget? child;

  final bool _empty;

  const BadExpandable({
    super.key,
    required this.open,
    required this.onToggle,
    this.onEnd,
    this.gap = 0,
    required this.headerBuilder,
    required this.child,
  }) : _empty = child == null;

  @override
  Widget build(BuildContext context) {
    final header = headerBuilder(
      _empty
          ? BadExpandableState.empty
          : open
              ? BadExpandableState.open
              : BadExpandableState.close,
    );

    if (_empty) return header;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      onEnd: onEnd,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadClickable(onClick: onToggle, child: header),
          if (open)
            gap > 0
                ? Padding(padding: EdgeInsets.only(top: gap), child: child!)
                : child!,
        ],
      ),
    );
  }
}
