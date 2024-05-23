import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

class BadExpandable extends StatefulWidget {
  /// whether the panel is open initially
  ///
  /// Default to `true`
  final bool initialOpen;

  /// height of the header
  ///
  /// Default to `28`
  final double headerHeight;

  /// gap between the header and the child
  ///
  /// Default to `0`
  final double gap;

  /// title widget
  final Widget title;

  /// icon to be displayed when the panel is empty
  ///
  /// Note: required when [child] is `null`
  final Widget? emptyIcon;

  /// icon to be displayed when the panel is open
  ///
  /// Default to `Icon(Icons.arrow_drop_up, size: 24)`
  final Widget openedIcon;

  /// icon to be displayed when the panel is closed
  ///
  /// Default to `Icon(Icons.arrow_drop_down, size: 24)`
  final Widget closedIcon;

  /// child widget to be displayed when the panel is open
  ///
  /// Note: if [child] is `null`, this widget will be treated as an empty panel.
  final Widget? child;

  const BadExpandable({
    super.key,
    this.initialOpen = true,
    this.headerHeight = 28,
    this.gap = 0,
    required this.title,
    this.openedIcon = const Icon(Icons.arrow_drop_up, size: 24),
    this.closedIcon = const Icon(Icons.arrow_drop_down, size: 24),
    required this.child,
  })  : assert(child != null),
        emptyIcon = null;

  const BadExpandable.empty({
    super.key,
    this.initialOpen = true,
    this.headerHeight = 28,
    this.gap = 0,
    required this.title,
    this.openedIcon = const Icon(Icons.arrow_drop_up, size: 24),
    this.closedIcon = const Icon(Icons.arrow_drop_down, size: 24),
    required this.emptyIcon,
  })  : assert(emptyIcon != null),
        child = null;

  @override
  State<BadExpandable> createState() => _BadExpandableState();
}

class _BadExpandableState extends State<BadExpandable> {
  bool _open = false;

  void toggle() {
    setState(() {
      _open = !_open;
    });
  }

  @override
  void initState() {
    super.initState();

    _open = widget.initialOpen;
  }

  @override
  Widget build(BuildContext context) {
    final header = SizedBox(
      height: widget.headerHeight,
      child: Row(
        children: [
          Expanded(child: widget.title),
          if (widget.child == null)
            widget.emptyIcon!
          else
            _open ? widget.openedIcon : widget.closedIcon,
        ],
      ),
    );

    if (widget.child == null) return header;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadClickable(onClick: toggle, child: header),
          if (_open && widget.gap > 0) SizedBox(height: widget.gap),
          if (_open) widget.child!,
        ],
      ),
    );
  }
}
