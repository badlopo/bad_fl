import 'package:flutter/material.dart';

class _AnchorManager<AnchorValue> {
  /// A map that stores the anchor-values and their corresponding keys.
  ///
  /// We store the keys instead of the offsets because the offsets may change when the layout changes,
  /// and we will use the keys to get the offsets when we need them.
  final Map<AnchorValue, GlobalKey> _anchors = {};

  void register(AnchorValue anchorValue, GlobalKey ref) {
    _anchors[anchorValue] = ref;
  }

  void deregister(AnchorValue anchorValue) {
    _anchors.remove(anchorValue);
  }
}

/// context provider
class _AnchoredScrollableProvider<AnchorValue> extends InheritedWidget {
  static _AnchoredScrollableProvider<AnchorValue> of<AnchorValue>(
      BuildContext context) {
    // final provider = context.dependOnInheritedWidgetOfExactType<
    //     _AnchoredScrollableProvider<AnchorValue>>();
    final provider = context.getInheritedWidgetOfExactType<
        _AnchoredScrollableProvider<AnchorValue>>();

    assert(provider != null,
        "Cannot find AnchoredScrollableProvider in the widget tree. Make sure you are using BadAnchoredScrollable as an ancestor widget.");

    return provider!;
  }

  final _AnchorManager<AnchorValue> anchorManager;

  const _AnchoredScrollableProvider({
    required this.anchorManager,
    required super.child,
  });

  @override
  bool updateShouldNotify(
      covariant _AnchoredScrollableProvider<AnchorValue> oldWidget) {
    return oldWidget.anchorManager != anchorManager;
  }
}

class _AnchoredScrollableAction<AnchorValue> {
  final bool animate;
  final AnchorValue anchorValue;
  final double? offset;
  final Duration? duration;
  final Curve? curve;

  const _AnchoredScrollableAction.jump(this.anchorValue, {this.offset})
      : animate = false,
        duration = null,
        curve = null;

  const _AnchoredScrollableAction.animate(
    this.anchorValue, {
    this.offset,
    required Duration this.duration,
    required Curve this.curve,
  }) : animate = true;

  @override
  String toString() {
    return '[AnchoredScrollableAction] ${animate ? 'animate' : 'jump'} to $anchorValue (offset: $offset)';
  }
}

class BadAnchoredScrollableController<AnchorValue> extends ChangeNotifier {
  _AnchoredScrollableAction<AnchorValue>? _action;

  void jumpToAnchor(AnchorValue anchorValue, {double offset = 0.0}) {
    _action = _AnchoredScrollableAction.jump(anchorValue, offset: offset);
    notifyListeners();
  }

  void animateToAnchor(
    AnchorValue anchorValue, {
    double offset = 0.0,
    required Duration duration,
    required Curve curve,
  }) {
    _action = _AnchoredScrollableAction.animate(
      anchorValue,
      offset: offset,
      duration: duration,
      curve: curve,
    );
    notifyListeners();
  }
}

/// A wrapper widget that makes its child as an anchor point to scroll to.
class BadScrollAnchor<AnchorValue> extends StatefulWidget {
  /// A value that uniquely identifies the anchor.
  ///
  /// This value SHOULD be unique among all the [BadScrollAnchor] widgets in the nearest ancestor [BadAnchoredScrollable]. (Same value will override the previous one)
  final AnchorValue anchorValue;

  /// The widget to be anchored.
  final Widget child;

  const BadScrollAnchor({
    super.key,
    required this.anchorValue,
    required this.child,
  });

  @override
  State<BadScrollAnchor<AnchorValue>> createState() => _ScrollAnchorState();
}

class _ScrollAnchorState<AnchorValue>
    extends State<BadScrollAnchor<AnchorValue>> {
  final ref = GlobalKey();

  _AnchorManager<AnchorValue>? _anchorManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // deregister self in old anchor manager (if any)
    _anchorManager?.deregister(widget.anchorValue);

    // hold a reference to the new anchor manager
    // and register self to it
    _anchorManager = _AnchoredScrollableProvider.of<AnchorValue>(context)
        .anchorManager
      ..register(widget.anchorValue, ref);
  }

  @override
  void didUpdateWidget(covariant BadScrollAnchor<AnchorValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _anchorManager
      ?..deregister(oldWidget.anchorValue)
      ..register(widget.anchorValue, ref);
  }

  @override
  void dispose() {
    _anchorManager?.deregister(widget.anchorValue);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: ref, child: widget.child);
  }
}

/// A widget that its children (those wrapped in [BadScrollAnchor] ) can be anchored and scrolled to.
///
/// NOTE: This widget uses [SingleChildScrollView] and [Column] to layout its children.
class BadAnchoredScrollable<AnchorValue> extends StatefulWidget {
  final BadAnchoredScrollableController<AnchorValue> controller;

  /// see [SingleChildScrollView.controller]
  ///
  /// If null, it will maintain its own [ScrollController] internally.
  final ScrollController? scrollController;

  /// see [SingleChildScrollView.scrollDirection]
  final Axis scrollDirection;

  /// see [SingleChildScrollView.padding]
  final EdgeInsetsGeometry? padding;

  /// see [SingleChildScrollView.physics]
  final ScrollPhysics? physics;

  /// Any widgets to be displayed in the scrollable area.
  /// Use [ScrollAnchor] to specify the anchor points to scroll to.
  final List<Widget> children;

  const BadAnchoredScrollable({
    super.key,
    required this.controller,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.physics,
    required this.children,
  });

  @override
  State<BadAnchoredScrollable<AnchorValue>> createState() =>
      _AnchoredScrollableState<AnchorValue>();
}

class _AnchoredScrollableState<AnchorValue>
    extends State<BadAnchoredScrollable<AnchorValue>> {
  final ref = GlobalKey();

  final _AnchorManager<AnchorValue> anchorManager = _AnchorManager();

  ScrollController? localScrollController;

  void _setupScrollControllerIfNeeded() {
    if (widget.scrollController == null && localScrollController == null) {
      localScrollController = ScrollController();
    }
  }

  ScrollController get scrollController =>
      widget.scrollController ?? localScrollController!;

  /// Calculate the anchor position in the scrollable area axis. (with extra offset)
  double? _calculateAnchorPositionInScrollable(
      AnchorValue anchorValue, double offset) {
    // find reference to the anchor element
    final anchorRef = anchorManager._anchors[anchorValue];

    // we just ignore if the anchor is not found
    if (anchorRef == null) return null;

    // find the container element and get its position in global axis
    final origin = (ref.currentContext!.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);

    // find the anchor element and get its position in global axis
    final anchorPoint =
        (anchorRef.currentContext!.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero);

    // calculate the anchor position relative to the container and apply the offset to it
    //
    // don't forget to add the current scroll offset to the anchor
    // position (since the result of 'localToGlobal' is based on
    // viewport rather than the whole scrollable area)
    final pos = switch (widget.scrollDirection) {
      Axis.vertical =>
        anchorPoint.dy + scrollController.offset - origin.dy + offset,
      Axis.horizontal =>
        anchorPoint.dx + scrollController.offset - origin.dx + offset,
    };

    // clamp the position to the scrollable area bounds
    // and return it as the final result
    return pos.clamp(0.0, scrollController.position.maxScrollExtent);
  }

  void handleUpdate() {
    final action = widget.controller._action;
    // unreachable condition, but just in case
    if (action == null) return;

    final targetPosition = _calculateAnchorPositionInScrollable(
        action.anchorValue, action.offset ?? 0);
    if (targetPosition == null) return;

    if (action.animate) {
      scrollController.animateTo(
        targetPosition,
        duration: action.duration!,
        curve: action.curve!,
      );
    } else {
      scrollController.jumpTo(targetPosition);
    }
  }

  @override
  void initState() {
    super.initState();

    _setupScrollControllerIfNeeded();
    widget.controller.addListener(handleUpdate);
  }

  @override
  void didUpdateWidget(covariant BadAnchoredScrollable<AnchorValue> oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.removeListener(handleUpdate);

    _setupScrollControllerIfNeeded();
    widget.controller.addListener(handleUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleUpdate);

    if (localScrollController != null) {
      localScrollController!.dispose();
      localScrollController = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ref,
      controller: scrollController,
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      physics: widget.physics,
      child: _AnchoredScrollableProvider(
        anchorManager: anchorManager,
        child: switch (widget.scrollDirection) {
          Axis.horizontal => Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          Axis.vertical => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
        },
      ),
    );
  }
}
