part of 'anchored_scrollable.dart';

/// A wrapper widget that makes its child as an anchor point to scroll to.
class ScrollAnchor<AnchorValue extends Object> extends StatefulWidget {
  /// A value that uniquely identifies the anchor.
  ///
  /// This value SHOULD be unique among all the [ScrollAnchor] widgets in the nearest ancestor [BadAnchoredScrollable]. (Same value will override the previous one)
  final AnchorValue anchorValue;

  // TODO: onShow
  // TODO: onHide

  /// The widget to be anchored.
  final Widget child;

  const ScrollAnchor({
    super.key,
    required this.anchorValue,
    required this.child,
  });

  @override
  State<ScrollAnchor<AnchorValue>> createState() =>
      _ScrollAnchorState<AnchorValue>();
}

class _ScrollAnchorState<AnchorValue extends Object>
    extends State<ScrollAnchor<AnchorValue>> {
  final _key = GlobalKey();

  // FIXME: maybe remove the 'final' as the widget may move to another widget with different controller
  // we should update it in 'didUpdateWidget'
  late final AnchoredScrollableController<AnchorValue> _controller;

  @override
  void initState() {
    super.initState();

    final asc = AnchoredScrollableController.of<AnchorValue>(context);
    if (asc == null) {
      throw StateError(
          'ScrollAnchor must be a descendant of BadAnchoredScrollable');
    }

    // hold the reference to nearest AnchoredScrollableController
    _controller = asc;

    // register anchorValue and key
    asc._anchors[widget.anchorValue] = _key;
  }

  @override
  void activate() {
    super.activate();

    // register anchorValue and key
    _controller._anchors[widget.anchorValue] = _key;
  }

  @override
  void deactivate() {
    super.deactivate();

    // deregister anchorValue and key
    _controller._anchors.remove(widget.anchorValue);
  }

  @override
  void didUpdateWidget(covariant ScrollAnchor<AnchorValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // deregister old anchorValue and key
    _controller._anchors.remove(oldWidget.anchorValue);
    // register new anchorValue and key
    _controller._anchors[widget.anchorValue] = _key;
  }

  @override
  void dispose() {
    // deregister anchorValue and key
    _controller._anchors.remove(widget.anchorValue);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
