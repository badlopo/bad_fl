import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// adsorb behavior of floating widget
enum BadFloatingAdsorb {
  /// adsorb to both horizontal and vertical (if equal, in order of left, right, top, bottom)
  both,

  /// adsorb to horizontal (if equal, adsorb to left)
  horizontal,

  /// adsorb to vertical (if equal, adsorb to top)
  vertical,

  /// no adsorb (keep the position as is)
  none,
}

/// position of floating widget
class BadFloatingPosition {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const BadFloatingPosition.tl(double this.top, double this.left)
      : right = null,
        bottom = null;

  const BadFloatingPosition.tr(double this.top, double this.right)
      : left = null,
        bottom = null;

  const BadFloatingPosition.bl(double this.bottom, double this.left)
      : top = null,
        right = null;

  const BadFloatingPosition.br(double this.bottom, double this.right)
      : top = null,
        left = null;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BadFloatingPosition &&
        other.left == left &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom;
  }

  @override
  String toString() {
    return 'BadFloatingPosition(top: $top, left: $left, right: $right, bottom: $bottom)';
  }
}

class _AdsorbArena {
  final double freeWidth;
  final double freeHeight;
  final BadFloatingAdsorb adsorb;
  final EdgeInsets adsorbInset;

  const _AdsorbArena({
    required this.freeWidth,
    required this.freeHeight,
    required this.adsorb,
    required this.adsorbInset,
  });

  /// get the position of floating widget after adsorb, return null if no adsorb applied
  BadFloatingPosition? compete(double top, double left) {
    switch (adsorb) {
      case BadFloatingAdsorb.none:
        return null;
      case BadFloatingAdsorb.horizontal:
        final double right = freeWidth - left;
        return left < right
            ? BadFloatingPosition.tl(top, -adsorbInset.left)
            : BadFloatingPosition.tl(top, freeWidth + adsorbInset.right);
      case BadFloatingAdsorb.vertical:
        final double bottom = freeHeight - top;
        return top < bottom
            ? BadFloatingPosition.tl(-adsorbInset.top, left)
            : BadFloatingPosition.tl(freeHeight + adsorbInset.bottom, left);
      case BadFloatingAdsorb.both:
        final double right = freeWidth - left;
        final double bottom = freeHeight - top;
        final double dis = min(min(left, top), min(right, bottom));

        if (dis == left) {
          return BadFloatingPosition.tl(top, -adsorbInset.left);
        } else if (dis == right) {
          return BadFloatingPosition.tl(top, freeWidth + adsorbInset.right);
        } else if (dis == top) {
          return BadFloatingPosition.tl(-adsorbInset.top, left);
        } else if (dis == bottom) {
          return BadFloatingPosition.tl(freeHeight + adsorbInset.bottom, left);
        }

        // unreachable
        return null;
    }
  }
}

class BadFloating extends StatefulWidget {
  /// the size of container where floating widget is placed
  final Size containerSize;

  /// the size of floating widget (the [child] will be constrained to this size)
  final Size floatingSize;

  /// adsorb behavior
  ///
  /// Default to `BadFloatingAdsorb.both`
  final BadFloatingAdsorb adsorb;

  /// the overflow distance when adsorbing to the edge
  ///
  /// Note: this works when adsorb is not `BadFloatingAdsorb.none`
  ///
  /// Default to `EdgeInsets.zero`
  final EdgeInsets adsorbInset;

  /// the duration of adsorb animation
  ///
  /// Note: this works when adsorb is not `BadFloatingAdsorb.none`
  ///
  /// Default to `Duration(milliseconds: 150)`
  final Duration adsorbDuration;

  /// the curve of adsorb animation
  ///
  /// Note: this works when adsorb is not `BadFloatingAdsorb.none`
  ///
  /// Default to `Curves.easeInOut`
  final Curve adsorbCurve;

  /// initial position of floating widget
  final BadFloatingPosition initialPosition;

  final Widget child;

  const BadFloating({
    super.key,
    required this.containerSize,
    required this.floatingSize,
    this.adsorb = BadFloatingAdsorb.both,
    this.adsorbInset = EdgeInsets.zero,
    this.adsorbDuration = const Duration(milliseconds: 150),
    this.adsorbCurve = Curves.easeInOut,
    required this.initialPosition,
    required this.child,
  }) : assert(
          containerSize > floatingSize,
          'container size must be greater than floating size',
        );

  @override
  State<BadFloating> createState() => _BadFloatingState();
}

class _BadFloatingState extends State<BadFloating> {
  late final _AdsorbArena _arena = _AdsorbArena(
    freeWidth: widget.containerSize.width - widget.floatingSize.width,
    freeHeight: widget.containerSize.height - widget.floatingSize.height,
    adsorb: widget.adsorb,
    adsorbInset: widget.adsorbInset,
  );

  late BadFloatingPosition _position = BadFloatingPosition.tl(
    widget.initialPosition.top ??
        _arena.freeHeight - widget.initialPosition.bottom!,
    widget.initialPosition.left ??
        _arena.freeWidth - widget.initialPosition.right!,
  );

  Duration _duration = Duration.zero;

  void _onAnimationEnd() => _duration = Duration.zero;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = BadFloatingPosition.tl(
        clampDouble(_position.top! + details.delta.dy, 0, _arena.freeHeight),
        clampDouble(_position.left! + details.delta.dx, 0, _arena.freeWidth),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final newPosition = _arena.compete(_position.top!, _position.left!);

    // only apply animation when adsorb is required
    if (newPosition != null && newPosition != _position) {
      setState(() {
        _position = newPosition;
        _duration = widget.adsorbDuration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _duration,
      left: _position.left,
      top: _position.top,
      width: widget.floatingSize.width,
      height: widget.floatingSize.height,
      onEnd: _onAnimationEnd,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: SizedBox(
          width: widget.floatingSize.width,
          height: widget.floatingSize.height,
          child: widget.child,
        ),
      ),
    );
  }
}
