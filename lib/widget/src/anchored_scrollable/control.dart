part of 'anchored_scrollable.dart';

class AnchoredScrollableController<AnchorValue extends Object> {
  /// Internal Use.
  ///
  /// Used in [ScrollAnchor] to find the nearest [AnchoredScrollableController].
  static AnchoredScrollableController<AnchorValue>?
      of<AnchorValue extends Object>(BuildContext context) {
    return context
        .findAncestorWidgetOfExactType<BadAnchoredScrollable<AnchorValue>>()
        ?.controller;
  }

  /// The scroll direction of the [BadAnchoredScrollable] widget that this controller is attached to.
  ///
  /// Configure this property here instead of in the [BadAnchoredScrollable] widget to make it easier to access.
  ///
  /// see [SingleChildScrollView.scrollDirection]
  final Axis scrollDirection;

  AnchoredScrollableController({this.scrollDirection = Axis.vertical});

  final GlobalKey _key = GlobalKey();
  final ScrollController _sc = ScrollController();

  /// A map that stores the anchors and their corresponding keys.
  ///
  /// We store the keys instead of the offsets because the offsets may change when the layout changes,
  /// and we will use the keys to find the offsets when we need them.
  final Map<AnchorValue, GlobalKey> _anchors = {};

  /// Get the target position of the anchor point specified by [anchorValue].
  double _getTargetPos(AnchorValue anchorValue, double offset) {
    // find reference to the anchor element
    final ref = _anchors[anchorValue];
    if (ref == null) throw StateError('Anchor not found: $anchorValue');

    // find the container element & get its position
    final container = _key.currentContext!.findRenderObject() as RenderBox;
    final origin = container.localToGlobal(Offset.zero);

    // find the anchor element & get its position
    final anchor = ref.currentContext!.findRenderObject() as RenderBox;
    final anchorPoint = anchor.localToGlobal(Offset.zero);

    // calculate the anchor position relative to the container and apply the offset to it
    //
    // don't forget to add the current scroll offset to the anchor
    // position (since the result of 'localToGlobal' is based on
    // viewport rather than the whole scrollable area)
    final pos = switch (scrollDirection) {
      Axis.vertical => anchorPoint.dy + _sc.offset - origin.dy + offset,
      Axis.horizontal => anchorPoint.dx + _sc.offset - origin.dx + offset,
    };

    // clamp the position to the scrollable area bounds
    // and return it as the final result
    return pos.clamp(0.0, _sc.position.maxScrollExtent);
  }

  /// jump to the anchor point specified by [anchorValue].
  ///
  /// [offset]: additional offset relative to the anchor point.
  void jumpToAnchor(AnchorValue anchorValue, {double offset = 0.0}) {
    final v = _getTargetPos(anchorValue, offset);
    _sc.jumpTo(v);
  }

  /// animate to the anchor point specified by [anchorValue].
  ///
  /// [offset]: additional offset relative to the anchor point.
  Future<void> animateToAnchor(
    AnchorValue anchorValue, {
    required Duration duration,
    required Curve curve,
    double offset = 0.0,
  }) {
    final v = _getTargetPos(anchorValue, offset);
    return _sc.animateTo(v, duration: duration, curve: curve);
  }

  /// delegate of [ScrollController.jumpTo]
  void jumpTo(double offset) {
    _sc.jumpTo(offset);
  }

  /// delegate of [ScrollController.jumpTo]
  Future<void> animateTo(
    double offset, {
    required Duration duration,
    required Curve curve,
  }) {
    return _sc.animateTo(offset, duration: duration, curve: curve);
  }
}
