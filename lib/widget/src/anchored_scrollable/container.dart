part of 'anchored_scrollable.dart';

/// A widget that makes its children (wrapped in [ScrollAnchor]) can be anchored and scrolled to.
///
/// This widget uses [SingleChildScrollView] and [Column] to layout its children.
class BadAnchoredScrollable<AnchorValue extends Object> extends StatefulWidget {
  final AnchoredScrollableController<AnchorValue> controller;

  /// see [SingleChildScrollView.padding]
  final EdgeInsetsGeometry? padding;

  /// see [SingleChildScrollView.physics]
  final ScrollPhysics? physics;

  /// Widgets to be displayed in the scrollable area.
  /// Use [ScrollAnchor] to specify the anchor points to scroll to.
  final List<Widget> children;

  const BadAnchoredScrollable({
    super.key,
    required this.controller,
    required this.children,
    this.padding,
    this.physics,
  });

  @override
  State<BadAnchoredScrollable<AnchorValue>> createState() =>
      _AnchoredScrollableState<AnchorValue>();
}

class _AnchoredScrollableState<AnchorValue extends Object>
    extends State<BadAnchoredScrollable<AnchorValue>> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: widget.controller._key,
      controller: widget.controller._sc,
      scrollDirection: widget.controller.scrollDirection,
      padding: widget.padding,
      physics: widget.physics,
      // wrap children in a column or row based on scrollDirection
      child: switch (widget.controller.scrollDirection) {
        Axis.vertical => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
        Axis.horizontal => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
      },
    );
  }
}
