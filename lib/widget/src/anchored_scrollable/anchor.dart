part of 'anchored_scrollable.dart';

/// A wrapper widget that makes its child as an anchor point to scroll to.
class ScrollAnchor<AnchorValue extends Object> extends StatefulWidget {
  /// A value that uniquely identifies the anchor.
  ///
  /// This value SHOULD be unique among all the [ScrollAnchor] widgets in the nearest ancestor [BadAnchoredScrollable]. (Same value will override the previous one)
  final AnchorValue anchorValue;

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
  /// Reference to the controller of nearest [BadAnchoredScrollable].
  AnchoredScrollableController<AnchorValue>? _controller;

  final _key = GlobalKey();

  /// Register self to controller.
  void _register() {
    _controller?._anchors[widget.anchorValue] = _key;
  }

  // Deregister self from controller.
  void _deregister(AnchorValue oldAnchorValue) {
    _controller?._anchors.remove(oldAnchorValue);
  }

  @override
  void initState() {
    super.initState();

    _register();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // deregister self in old controller
    _deregister(widget.anchorValue);

    // get and cache new controller
    final provider = context.dependOnInheritedWidgetOfExactType<
        _AnchoredScrollProvider<AnchorValue>>();
    assert(provider != null,
        "ScrollAnchor must be a descendant of BadAnchoredScrollable");

    _controller = provider!.controller;

    // register self to latest controller
    // NOTE: we also do first register here since we cannot get provider in 'initState'.
    _register();
  }

  @override
  void activate() {
    super.activate();

    _register();
  }

  @override
  void deactivate() {
    _deregister(widget.anchorValue);

    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant ScrollAnchor<AnchorValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // no-op if anchorValue keep the same
    if (oldWidget.anchorValue == widget.anchorValue) return;

    _deregister(oldWidget.anchorValue);
    _register();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
