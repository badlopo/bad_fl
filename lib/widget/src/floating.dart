import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Adsorb behavior of floating widget.
enum AdsorbStrategy {
  /// Adsorb to both horizontal and vertical (if equal, in order of left, right, top, bottom).
  both,

  /// Adsorb to horizontal (if equal, adsorb to left).
  horizontal,

  /// Adsorb to vertical (if equal, adsorb to top).
  vertical,

  /// No adsorb (keep the position as is).
  none,
}

/// Describe the position of floating widget in two demension.
class FloatingPosition {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const FloatingPosition.tl(double this.top, double this.left)
      : right = null,
        bottom = null;

  const FloatingPosition.tr(double this.top, double this.right)
      : left = null,
        bottom = null;

  const FloatingPosition.bl(double this.bottom, double this.left)
      : top = null,
        right = null;

  const FloatingPosition.br(double this.bottom, double this.right)
      : top = null,
        left = null;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FloatingPosition &&
        other.left == left &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom;
  }

  @override
  String toString() {
    return 'FloatingPosition(top: $top, left: $left, right: $right, bottom: $bottom)';
  }
}

/// Arena for adsorb competition.
class _AdsorbArena {
  final double freeWidth;
  final double freeHeight;
  final AdsorbStrategy adsorb;
  final EdgeInsets adsorbInset;

  const _AdsorbArena({
    required this.freeWidth,
    required this.freeHeight,
    required this.adsorb,
    required this.adsorbInset,
  });

  /// get the position of floating widget after adsorb, return null if no adsorb applied
  FloatingPosition? compete(double top, double left) {
    switch (adsorb) {
      case AdsorbStrategy.none:
        return null;
      case AdsorbStrategy.horizontal:
        final double right = freeWidth - left;
        return left < right
            ? FloatingPosition.tl(top, -adsorbInset.left)
            : FloatingPosition.tl(top, freeWidth + adsorbInset.right);
      case AdsorbStrategy.vertical:
        final double bottom = freeHeight - top;
        return top < bottom
            ? FloatingPosition.tl(-adsorbInset.top, left)
            : FloatingPosition.tl(freeHeight + adsorbInset.bottom, left);
      case AdsorbStrategy.both:
        final double right = freeWidth - left;
        final double bottom = freeHeight - top;
        final double dis = min(min(left, top), min(right, bottom));

        if (dis == left) {
          return FloatingPosition.tl(top, -adsorbInset.left);
        } else if (dis == right) {
          return FloatingPosition.tl(top, freeWidth + adsorbInset.right);
        } else if (dis == top) {
          return FloatingPosition.tl(-adsorbInset.top, left);
        } else if (dis == bottom) {
          return FloatingPosition.tl(freeHeight + adsorbInset.bottom, left);
        }

        // unreachable
        return null;
    }
  }
}

/// Note: this should be used within a [Stack] widget.
class BadFloating extends StatefulWidget {
  /// Size of container where floating widget is placed.
  final Size containerSize;

  /// Size of floating widget (the [child] will be constrained to this size).
  final Size floatingSize;

  /// Adsorb behavior.
  ///
  /// Default to `AdsorbStrategy.both`.
  final AdsorbStrategy adsorb;

  /// Overflow distance when adsorbing to the edge.
  ///
  /// Note: this works when adsorb is not `AdsorbStrategy.none`
  ///
  /// Default to `EdgeInsets.zero`.
  final EdgeInsets adsorbInset;

  /// Duration of adsorb animation.
  ///
  /// Note: this works when adsorb is not `AdsorbStrategy.none`.
  ///
  /// Default to `Duration(milliseconds: 150)`.
  final Duration adsorbDuration;

  /// Curve of adsorb animation.
  ///
  /// Note: this works when adsorb is not `AdsorbStrategy.none`.
  ///
  /// Default to `Curves.easeInOut`.
  final Curve adsorbCurve;

  /// Initial position of floating widget.
  final FloatingPosition initialPosition;

  final Widget child;

  const BadFloating({
    super.key,
    required this.containerSize,
    required this.floatingSize,
    this.adsorb = AdsorbStrategy.both,
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
  State<BadFloating> createState() => _FloatingState();
}

class _FloatingState extends State<BadFloating> {
  late final _AdsorbArena _arena = _AdsorbArena(
    freeWidth: widget.containerSize.width - widget.floatingSize.width,
    freeHeight: widget.containerSize.height - widget.floatingSize.height,
    adsorb: widget.adsorb,
    adsorbInset: widget.adsorbInset,
  );

  late FloatingPosition _position = FloatingPosition.tl(
    widget.initialPosition.top ??
        _arena.freeHeight - widget.initialPosition.bottom!,
    widget.initialPosition.left ??
        _arena.freeWidth - widget.initialPosition.right!,
  );

  Duration _duration = Duration.zero;

  void _onAnimationEnd() => _duration = Duration.zero;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = FloatingPosition.tl(
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
