import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

enum BadExpandableState { empty, open, close }

class BadExpandable extends StatefulWidget {
  /// whether the panel is open initially
  ///
  /// Default to `true`
  final bool openOnInit;

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

  const BadExpandable({
    super.key,
    this.openOnInit = true,
    this.gap = 0,
    required this.headerBuilder,
    required this.child,
  });

  @override
  State<BadExpandable> createState() => _BadExpandableState();
}

class _BadExpandableState extends State<BadExpandable> {
  late final bool _empty = widget.child == null;
  late bool _open = widget.openOnInit;

  void toggle() {
    setState(() => _open = !_open);
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.headerBuilder(
      _empty
          ? BadExpandableState.empty
          : _open
              ? BadExpandableState.open
              : BadExpandableState.close,
    );

    if (_empty) return header;

    Widget child = BadClickable(onClick: toggle, child: widget.child!);
    if (widget.gap > 0) {
      child = Padding(padding: EdgeInsets.only(top: widget.gap), child: child);
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadClickable(onClick: toggle, child: header),
          if (_open) child,
        ],
      ),
    );
  }
}
