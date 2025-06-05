import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum AdsorbStrategy {
  /// Adsorb to the closest edge, either horizontal or vertical.
  both,

  /// Adsorb to horizontal (if equal, adsorb to left).
  horizontal,

  /// Adsorb to vertical (if equal, adsorb to top).
  vertical,

  /// No adsorb (keep the position as is).
  none,
}

/// Position describer for [BadAdsorb].
class AdsorbPosition {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const AdsorbPosition.tl(double this.top, double this.left)
      : right = null,
        bottom = null;

  const AdsorbPosition.tr(double this.top, double this.right)
      : left = null,
        bottom = null;

  const AdsorbPosition.bl(double this.bottom, double this.left)
      : top = null,
        right = null;

  const AdsorbPosition.br(double this.bottom, double this.right)
      : top = null,
        left = null;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdsorbPosition &&
        other.left == left &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom;
  }

  @override
  String toString() {
    final pos = [
      if (top != null) 'top: $top',
      if (bottom != null) 'bottom: $bottom',
      if (left != null) 'left: $left',
      if (right != null) 'right: $right',
    ].join(', ');
    return 'AdsorbPosition($pos)';
  }
}

class _AdsorbArena {
  final AdsorbStrategy strategy;

  /// The size of the available space (i.e. the size of the parent container minus the size of the child).
  final Size spaceSize;

  final EdgeInsets insets;

  const _AdsorbArena({
    required this.strategy,
    required this.spaceSize,
    required this.insets,
  });

  /// calculate the final position after absorption,
  /// return null if no absorption is applied.
  AdsorbPosition? getFinalPosition(double top, double left) {
    switch (strategy) {
      case AdsorbStrategy.none:
        return null;
      case AdsorbStrategy.horizontal:
        final double right = spaceSize.width - left;
        return left < right
            ? AdsorbPosition.tl(top, insets.left)
            : AdsorbPosition.tl(top, spaceSize.width - insets.right);
      case AdsorbStrategy.vertical:
        final double bottom = spaceSize.height - top;
        return top < bottom
            ? AdsorbPosition.tl(insets.top, left)
            : AdsorbPosition.tl(spaceSize.height - insets.bottom, left);
      case AdsorbStrategy.both:
        final double right = spaceSize.width - left;
        final double bottom = spaceSize.height - top;
        final double dis = min(min(left, top), min(right, bottom));

        if (dis == left) {
          return AdsorbPosition.tl(top, insets.left);
        } else if (dis == right) {
          return AdsorbPosition.tl(top, spaceSize.width - insets.right);
        } else if (dis == top) {
          return AdsorbPosition.tl(insets.top, left);
        } else if (dis == bottom) {
          return AdsorbPosition.tl(spaceSize.height - insets.bottom, left);
        }

        // unreachable
        return null;
    }
  }
}

/// Limitation: Due to the author's limited knowledge,
/// the current implementation of this component requires
/// user to manually pass the parent container size ([parentSize]) for layout.
///
/// The use of this component will be as follows:
///
/// ```
/// LayoutBuilder(builder: (_, constraints) {
///   return Stack(
///     children: [
///       BadAdsorb(
///         initialPosition: AdsorbPosition.tl(60, 60),
///         insets: EdgeInsets.all(-20),
///         parentSize: constraints.biggest,
///         size: Size(50, 50),
///         child: Container(
///           color: Colors.red,
///         ),
///       ),
///     ],
///   );
/// ```
class BadAdsorb extends StatefulWidget {
  final AdsorbStrategy strategy;

  /// Initial position of the widget.
  final AdsorbPosition initialPosition;

  /// The edge offset applied after absorption.
  final EdgeInsets insets;

  /// Size of container where floating widget is placed.
  ///
  /// TODO: OPTIMIZE with [ParentDataWidget]
  final Size parentSize;

  /// Size of [child].
  final Size size;

  /// Duration of adsorb animation.
  final Duration duration;

  /// Curve of adsorb animation.
  final Curve curve;

  final Widget child;

  const BadAdsorb({
    super.key,
    this.strategy = AdsorbStrategy.both,
    this.insets = EdgeInsets.zero,
    this.initialPosition = const AdsorbPosition.tl(0, 0),
    required this.parentSize,
    required this.size,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    required this.child,
  }) : assert(parentSize > size);

  @override
  State<BadAdsorb> createState() => _AdsorbState();
}

class _AdsorbState extends State<BadAdsorb> {
  late _AdsorbArena _arena;
  late AdsorbPosition _position;

  void _setup() {
    _arena = _AdsorbArena(
      strategy: widget.strategy,
      spaceSize: Size(
        widget.parentSize.width - widget.size.width,
        widget.parentSize.height - widget.size.height,
      ),
      insets: widget.insets,
    );
    _position = AdsorbPosition.tl(
      widget.initialPosition.top ??
          _arena.spaceSize.height - widget.initialPosition.bottom!,
      widget.initialPosition.left ??
          _arena.spaceSize.width - widget.initialPosition.right!,
    );
  }

  Duration _duration = Duration.zero;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = AdsorbPosition.tl(
        clampDouble(
          _position.top! + details.delta.dy,
          widget.insets.top,
          _arena.spaceSize.height - widget.insets.bottom,
        ),
        clampDouble(
          _position.left! + details.delta.dx,
          widget.insets.left,
          _arena.spaceSize.width - widget.insets.right,
        ),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final newPosition =
        _arena.getFinalPosition(_position.top!, _position.left!);

    // only apply animation when adsorb is required
    if (newPosition != null && newPosition != _position) {
      setState(() {
        _position = newPosition;
        _duration = widget.duration;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _setup();
  }

  @override
  void didUpdateWidget(covariant BadAdsorb oldWidget) {
    super.didUpdateWidget(oldWidget);

    _setup();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _duration,
      left: _position.left,
      top: _position.top,
      width: widget.size.width,
      height: widget.size.height,
      // There is no need to use setState to trigger the update here.
      // We just need to update the value so that the animation will
      // not be displayed the next time the position is updated.
      onEnd: () => _duration = Duration.zero,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: SizedBox.fromSize(size: widget.size, child: widget.child),
      ),
    );
  }
}
