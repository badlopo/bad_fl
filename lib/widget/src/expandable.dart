import 'package:bad_fl/widget/src/clickable.dart';
import 'package:flutter/material.dart';

/// Expandable panel with controlled open state.
class BadExpandableControlled extends StatelessWidget {
  /// Whether the panel is open.
  final bool open;

  /// Callback when the header is clicked.
  final VoidCallback onToggle;

  /// Callback when the animation is finished.
  final VoidCallback? onEnd;

  /// Gap between the header and the child.
  ///
  /// Default to `0`.
  final double gap;

  /// Builder for the header widget.
  final Widget Function(bool open) headerBuilder;

  /// Widget to be displayed when the panel is open.
  final Widget child;

  const BadExpandableControlled({
    super.key,
    required this.open,
    required this.onToggle,
    this.onEnd,
    this.gap = 0,
    required this.headerBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      onEnd: onEnd,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadClickable(onClick: onToggle, child: headerBuilder(open)),
          if (open)
            gap > 0
                ? Padding(padding: EdgeInsets.only(top: gap), child: child)
                : child,
        ],
      ),
    );
  }
}

/// Expandable panel with self-maintained open state.
class BadExpandable extends StatefulWidget {
  /// Whether the panel is open initially.
  final bool initialOpen;

  /// Callback when the open state changed.
  final ValueChanged<bool>? onChanged;

  /// Gap between the header and the child.
  ///
  /// Default to `0`.
  final double gap;

  /// Builder for the header widget.
  final Widget Function(bool open) headerBuilder;

  /// Widget to be displayed when the panel is open.
  final Widget child;

  const BadExpandable({
    super.key,
    this.initialOpen = true,
    this.onChanged,
    this.gap = 0,
    required this.headerBuilder,
    required this.child,
  });

  @override
  State<BadExpandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<BadExpandable> {
  late bool open;

  @override
  void initState() {
    super.initState();
    open = widget.initialOpen;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      onEnd: () => widget.onChanged?.call(open),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadClickable(
            onClick: () => setState(() => open = !open),
            child: widget.headerBuilder(open),
          ),
          if (open)
            widget.gap > 0
                ? Padding(
                    padding: EdgeInsets.only(top: widget.gap),
                    child: widget.child,
                  )
                : widget.child,
        ],
      ),
    );
  }
}
