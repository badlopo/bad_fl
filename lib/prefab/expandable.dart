import 'package:flutter/material.dart';

import 'clickable.dart';

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

/// maintain the open state of the panel internally, expose a [onOpenChanged] callback when the open state changed
class BadExpandableSimple extends StatefulWidget {
  /// whether the panel is open initially
  final bool open;

  /// callback when the open state changed
  final ValueChanged? onOpenChanged;

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

  const BadExpandableSimple({
    super.key,
    this.open = true,
    this.onOpenChanged,
    this.gap = 0,
    required this.headerBuilder,
    required this.child,
  });

  @override
  State<BadExpandableSimple> createState() => _BadExpandableSimpleState();
}

class _BadExpandableSimpleState extends State<BadExpandableSimple> {
  late final bool _empty;
  late bool open;

  @override
  void initState() {
    super.initState();
    _empty = widget.child == null;
    open = widget.open;
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.headerBuilder(
      _empty
          ? BadExpandableState.empty
          : open
              ? BadExpandableState.open
              : BadExpandableState.close,
    );

    if (_empty) return header;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      onEnd: () => widget.onOpenChanged?.call(open),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadClickable(
            onClick: () => setState(() => open = !open),
            child: header,
          ),
          if (open)
            widget.gap > 0
                ? Padding(
                    padding: EdgeInsets.only(top: widget.gap),
                    child: widget.child!,
                  )
                : widget.child!,
        ],
      ),
    );
  }
}
