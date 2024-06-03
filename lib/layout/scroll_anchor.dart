import 'dart:async';

import 'package:bad_fl/core.dart';
import 'package:flutter/material.dart';

enum AnchorStatus {
  /// the delta between the current position and the previous position is positive
  hide,

  /// the delta between the current position and the previous position is negative
  show
}

typedef BadScrollObserver<AsKey> = void Function(
    AsKey key, AnchorStatus status);

class BadScrollAnchorController<AsKey extends Object> {
  /// find the `BadScrollAnchorController` of the nearest scope
  ///
  /// return `null` if not found
  static BadScrollAnchorController<AsKey>? of<AsKey extends Object>(
      BuildContext context) {
    return context
        .findAncestorWidgetOfExactType<BadScrollAnchorScope<AsKey>>()
        ?.controller;
  }

  void _ensureReady() {
    if (_scrollController == null) {
      throw StateError('The instance is not attached');
    }
    if (!_scrollController!.hasClients) {
      throw StateError('The "controller" of "builder" is not attached');
    }
    if (_containerKey.currentContext == null) {
      throw StateError('The "key" of "builder" is not attached');
    }
  }

  // region anchor management

  /// the `GlobalKey` for the inner `ScrollView`
  final GlobalKey _containerKey = GlobalKey(debugLabel: 'container');

  /// a mapping of user-supplied values (used as key) to internally maintained GlobalKeys
  ///
  /// Note: here we store key rather than position.
  /// because the position may change when the list is updated,
  /// we need to re-calculate the position real-time
  final Map<AsKey, GlobalKey> _valueToKey = <AsKey, GlobalKey>{};

  /// number of anchor in the scope
  int get anchorCount => _valueToKey.length;

  /// all the anchor points in the scope
  Iterable<AsKey> get anchors => _valueToKey.keys;

  /// add a anchor point, ignore if the key already exists
  void _addAnchor(AsKey asKey, GlobalKey key) {
    if (_valueToKey.containsKey(asKey)) {
      BadFl.log(
        module: 'BadScrollAnchor',
        message: 'the key $asKey already exists',
      );
      return;
    }

    _valueToKey[asKey] = key;
    BadFl.log(module: 'BadScrollAnchor', message: 'add anchor <$asKey>');
  }

  /// remove a anchor point
  void _removeAnchor(AsKey asKey) {
    _valueToKey.remove(asKey);
    BadFl.log(module: 'BadScrollAnchor', message: 'remove anchor <$asKey>');
  }

  // endregion

  // region jump/animate to anchor
  /// try to get the position of the inner `ScrollView` in global coordinates
  /// return `null` if the widget is not mounted
  double? _getOriginPositionInGlobal() {
    // guard -- ensure the widget is mounted so that we can get the RenderObject
    if (!_containerMounted) {
      BadFl.log(
        module: 'BadScrollAnchor',
        message: 'the container widget is not mounted',
      );
      return null;
    }

    final ref = _containerKey.currentContext!.findRenderObject() as RenderBox;
    final tl = ref.localToGlobal(Offset.zero);

    switch (scrollDirection) {
      case Axis.vertical:
        return tl.dy;
      case Axis.horizontal:
        return tl.dx;
    }
  }

  double _getAnchorPositionInGlobal(GlobalKey anchorKey) {
    final ref = anchorKey.currentContext!.findRenderObject() as RenderBox;
    final tl = ref.localToGlobal(Offset.zero);

    switch (scrollDirection) {
      case Axis.vertical:
        return tl.dy;
      case Axis.horizontal:
        return tl.dx;
    }
  }

  double _clampInScrollable(double targetPos) {
    final maxPos = _scrollController!.position.maxScrollExtent;
    return targetPos.clamp(0, maxPos);
  }

  /// get the target position related to the key with an optional offset
  double? _getAnchorPosInScrollable(AsKey key, [double offset = 0]) {
    _ensureReady();

    final anchorKey = _valueToKey[key];
    if (anchorKey == null) {
      BadFl.log(
        module: 'BadScrollAnchor',
        message: 'no anchor related to the key $key',
      );
      return null;
    } else {
      final originPosGlobal = _getOriginPositionInGlobal();
      if (originPosGlobal == null) return null;

      final anchorPosGlobal = _getAnchorPositionInGlobal(anchorKey);
      final scrolledDis = _scrollController!.offset;

      double anchorPosInside = anchorPosGlobal + scrolledDis - originPosGlobal;
      double targetPos = anchorPosInside + offset;

      return _clampInScrollable(targetPos);
    }
  }

  /// jump to the anchor point related to the key with an optional offset
  void jumpToAnchor(AsKey key, [double offset = 0]) {
    double? targetPos = _getAnchorPosInScrollable(key, offset);
    if (targetPos != null) _scrollController!.jumpTo(targetPos);
  }

  /// animate to the anchor point related to the key with an optional offset
  FutureOr<void> animateToAnchor(
    AsKey key, {
    required Duration duration,
    required Curve curve,
    double offset = 0,
  }) {
    double? targetPos = _getAnchorPosInScrollable(key, offset);
    if (targetPos != null) {
      return _scrollController!
          .animateTo(targetPos, duration: duration, curve: curve);
    }
  }

  // endregion

  // region observer management
  /// a mapping of the position of the anchor points to the user-supplied values (used as key) stored in form of `List<(position, key)>`
  ///
  /// Note: this is more a snapshot of the position of the anchor points.
  /// this will be updated when:
  /// - a anchor point is added/removed
  /// - the [updateAnchorPos] is called
  List<(double, AsKey)> _posToValue = [];

  /// update the position of the anchor points in the scope so that the observers can be notified accurately
  void updateAnchorPos() {
    _ensureReady();

    final originPosGlobal = _getOriginPositionInGlobal();
    if (originPosGlobal == null) return;

    final scrollOffset = _scrollController!.offset;

    _posToValue = _valueToKey.entries.map((entry) {
      final posGlobal = _getAnchorPositionInGlobal(entry.value);
      double pos = posGlobal + scrollOffset - originPosGlobal;
      return (pos, entry.key);
    }).toList()
      ..sort((a, b) => a.$1.compareTo(b.$1));

    BadFl.log(module: 'BadScrollAnchor', message: 'anchor positions updated');
  }

  double _lastOffset = 0;

  /// determine the event of the delta between the current position and the previous position
  (AsKey, AnchorStatus)? _frameEvent() {
    final currentOffset = _scrollController!.offset;

    if (currentOffset > _lastOffset) {
      // offset increase -- AnchorStatus.hide
      for (final (pos, key) in _posToValue) {
        if (currentOffset > pos && _lastOffset <= pos) {
          return (key, AnchorStatus.hide);
        }
      }
    } else if (currentOffset < _lastOffset) {
      // offset decrease -- AnchorStatus.show
      for (final (pos, key) in _posToValue.reversed) {
        if (currentOffset < pos && _lastOffset >= pos) {
          return (key, AnchorStatus.show);
        }
      }
    }

    return null;
  }

  void _scrollListener() {
    final currentOffset = _scrollController!.offset;

    final event = _frameEvent();
    if (event != null) {
      final (key, status) = event;
      for (final observer in _observers) {
        observer(key, status);
      }
    }

    _lastOffset = currentOffset;
  }

  /// a set of observers that will be notified when an anchor passes by
  final Set<BadScrollObserver<AsKey>> _observers = {};

  void addObserver(BadScrollObserver<AsKey> observer) {
    _observers.add(observer);
  }

  void removeObserver(BadScrollObserver<AsKey> observer) {
    _observers.remove(observer);
  }

  // endregion

  // region lifecycle
  /// whether the 'BadScrollAnchorScope' is mounted
  bool _containerMounted = false;

  void _attach(ScrollController scrollController) {
    if (_scrollController != null) {
      throw StateError('The instance is already attached');
    }
    _scrollController = scrollController;
    scrollController.addListener(_scrollListener);

    BadFl.log(
      module: 'BadScrollAnchorController',
      message: 'attached to the "BadScrollAnchorScope"',
    );
  }

  void _detach() {
    _scrollController!.removeListener(_scrollListener);
    _scrollController = null;

    BadFl.log(
      module: 'BadScrollAnchorController',
      message: 'detached from the "BadScrollAnchorScope"',
    );
  }

  // endregion

  /// the `ScrollController` of the inner `ScrollView`
  ScrollController? _scrollController;

  /// the scrollDirection of the inner `ScrollView`
  ///
  /// Default to `Axis.vertical`
  final Axis scrollDirection;

  BadScrollAnchorController({this.scrollDirection = Axis.vertical});
}

/// a wrapper widget that provides a anchor point for the inner widget
class BadScrollAnchor<AsKey extends Object> extends StatefulWidget {
  /// value to be used as key
  final AsKey asKey;

  /// inner widget
  final Widget child;

  const BadScrollAnchor({super.key, required this.asKey, required this.child});

  @override
  State<BadScrollAnchor<AsKey>> createState() => _BadScrollAnchorState<AsKey>();
}

class _BadScrollAnchorState<AsKey extends Object>
    extends State<BadScrollAnchor<AsKey>> {
  /// the `GlobalKey` for the internal usage
  final _anchorKey = GlobalKey();

  /// the `BadScrollAnchorController` of the nearest scope
  late final BadScrollAnchorController<AsKey> controller;

  @override
  void initState() {
    super.initState();
    final controller = BadScrollAnchorController.of<AsKey>(context);
    if (controller == null) {
      throw Exception(
          '"BadScrollAnchor<$AsKey>" should be used within "BadScrollAnchorScope<$AsKey>"');
    }

    // hold the controller of 'BadScrollAnchorScope'
    this.controller = controller;

    // add the anchor point when the widget is initialized
    controller._addAnchor(widget.asKey, _anchorKey);

    // update the position of the anchor points in the scope after the layout is built
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.updateAnchorPos());
  }

  @override
  void dispose() {
    // remove the anchor point when the widget is disposed
    controller._removeAnchor(widget.asKey);

    // update the position of the anchor points in the scope
    controller.updateAnchorPos();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _anchorKey, child: widget.child);
  }
}

class BadScrollAnchorScope<AsKey extends Object> extends StatefulWidget {
  /// passed into the inner `SingleChildScrollView`
  final Axis scrollDirection;

  /// passed into the inner `SingleChildScrollView`
  final EdgeInsetsGeometry? padding;

  /// passed to the inner `SingleChildScrollView`
  final ScrollPhysics? physics;

  /// passed to the inner `SingleChildScrollView`
  ///
  /// if not provided, a internal `ScrollController` will be maintained
  final ScrollController? scrollController;

  /// passed to the inner `Column`
  final CrossAxisAlignment crossAxisAlignment;

  /// an object that can be used to control the anchor point that this scroll view scrolls to
  final BadScrollAnchorController<AsKey> controller;

  /// widgets to be placed inside the inner `SingleChildScrollView` (wrapped in a `Column`)
  final List<Widget> children;

  const BadScrollAnchorScope({
    super.key,
    required this.controller,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.physics,
    this.scrollController,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  });

  @override
  State<BadScrollAnchorScope<AsKey>> createState() =>
      _BadScrollAnchorScopeState<AsKey>();
}

class _BadScrollAnchorScopeState<AsKey extends Object>
    extends State<BadScrollAnchorScope<AsKey>> {
  late final ScrollController sc;

  @override
  void initState() {
    super.initState();
    sc = widget.scrollController ?? ScrollController();
    widget.controller._attach(sc);

    // mark the container widget as mounted after the layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller._containerMounted = true;
    });
  }

  @override
  void activate() {
    widget.controller._containerMounted = true;
    super.activate();
  }

  @override
  void deactivate() {
    // we need to mark the container widget as unmounted here to make sure it before children widgets' 'dispose' method
    widget.controller._containerMounted = false;
    super.deactivate();
  }

  @override
  void dispose() {
    widget.controller._detach();
    // only dispose the controller maintained by the widget
    if (widget.scrollController == null) {
      sc.dispose();
      BadFl.log(
        module: 'BadScrollAnchorScope',
        message: 'internally maintained "ScrollController" disposed',
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: widget.controller._containerKey,
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      physics: widget.physics,
      controller: sc,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: widget.children,
      ),
    );
  }
}
