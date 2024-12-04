import 'package:bad_fl/widget/src/clickable.dart';
import 'package:flutter/material.dart';

/// Wrap a widget within [BadPreview] to enable previewing the widget when clicked.
class BadPreview extends StatefulWidget {
  /// The color to use as mask when previewing the widget.
  final Color maskColor;

  /// The widget to display on the screen.
  final Widget child;

  /// The widget to display as a preview, if not provided, [child] will be used.
  final Widget? preview;

  const BadPreview({
    super.key,
    this.maskColor = Colors.black,
    required this.child,
    this.preview,
  });

  @override
  State<BadPreview> createState() => _PreviewState();
}

class _PreviewState extends State<BadPreview> {
  final heroTag = UniqueKey();

  void showPreview() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) {
          return _PreviewView(
            heroTag: heroTag,
            maskColor: widget.maskColor,
            child: widget.preview ?? widget.child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: BadClickable(onClick: showPreview, child: widget.child),
    );
  }
}

class _PreviewView extends StatefulWidget {
  final UniqueKey heroTag;
  final Color maskColor;
  final Widget child;

  const _PreviewView({
    required this.heroTag,
    required this.maskColor,
    required this.child,
  });

  @override
  State<_PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<_PreviewView> {
  /// scale factor to apply when double tap
  static const _sf = 1.5;

  /// threshold for drag to close
  static const _thresholdY = 150;

  /// duration for [AnimatedPositioned] to reset position
  static const _resetDuration = Duration(milliseconds: 150);

  final controller = TransformationController();

  void hidePreview() {
    Navigator.of(context).pop();
  }

  /// matrix to apply scale (use center of the screen as anchor point)
  Matrix4 get _sfMat {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2);
    final dx = center.dx * _sf - center.dx;
    final dy = center.dy * _sf - center.dy;

    final applyScale = Matrix4.identity()..scale(_sf, _sf, 1.0);
    final moveToOrigin = Matrix4.identity()
      ..translate(-dx * _sf, -dy * _sf, 0.0);
    final moveBack = Matrix4.identity()..translate(dx, dy, 0.0);

    return applyScale * moveToOrigin * moveBack;
  }

  /// apply action depend on current scale
  /// - scale to [_sf] if current scale is 1.0
  /// - scale to 1.0 if current scale is not 1.0
  void toggleScale() {
    final double maxScale = controller.value.getMaxScaleOnAxis();

    if (maxScale != 1) {
      final Matrix4 mat = Matrix4.identity()..scale(1.0, 1.0, 1.0);
      controller.value = mat;
    } else {
      controller.value = _sfMat;

      // // use tap point as anchor point
      // // the point of double tap (anchor)
      // final double cx = details.localPosition.dx;
      // final double cy = details.localPosition.dy;
      //
      // final Matrix4 applyScale = Matrix4.identity()..scale(_sf, _sf, 1.0);
      // final Matrix4 moveToOrigin = Matrix4.identity()
      //   ..translate(-cx * _sf, -cy * _sf, 0.0);
      // // final Matrix4 moveBack = Matrix4.identity()..translate(cx, cy, 0.0);
      // final Matrix4 moveBack = Matrix4.translationValues(cx, cy, 0.0);
      //
      // // steps to apply scale to anchor point:
      // // 1. apply scale
      // // 2. move the anchor point to the origin point
      // // 3. move the anchor point back to its original position
      // final mat = applyScale * moveToOrigin * moveBack;
      //
      // // apply scale to center
      // controller.value = mat;
    }
  }

  /// initial Y of drag
  double _initialY = 0.0;

  /// delta Y of drag
  double _deltaY = 0.0;

  /// duration to apply for [AnimatedPositioned] widget
  Duration _appliedDuration = Duration.zero;

  bool _isDragging = false;

  void _dragStart(Offset pos) {
    _initialY = pos.dy;
    _isDragging = true;
  }

  void _dragUpdate(Offset pos) {
    setState(() {
      _deltaY = pos.dy - _initialY;
    });
  }

  void _dragEnd() {
    if (_deltaY > _thresholdY || _deltaY < -_thresholdY) {
      // close preview
      hidePreview();
    } else {
      // clear drag effect
      setState(() {
        _initialY = 0.0;
        _deltaY = 0.0;
        _appliedDuration = _resetDuration;
      });
      // reset duration after position has been reset (to avoid animation when user drag/scale)
      Future.delayed(_resetDuration).then(
        (_) => setState(() {
          _appliedDuration = Duration.zero;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double shrinkX = _deltaY.abs() / 15.0;

    return Hero(
      tag: widget.heroTag,
      child: Scaffold(
        backgroundColor: widget.maskColor,
        body: GestureDetector(
          onTap: hidePreview,
          onDoubleTap: toggleScale,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: _appliedDuration,
                top: 0 + _deltaY,
                bottom: 0 - _deltaY,
                left: shrinkX,
                right: shrinkX,
                child: InteractiveViewer(
                  panEnabled: false,
                  transformationController: controller,
                  onInteractionStart: (ScaleStartDetails details) {
                    if (details.pointerCount == 1) {
                      _dragStart(details.focalPoint);
                    }
                  },
                  onInteractionUpdate: (ScaleUpdateDetails details) {
                    if (details.pointerCount == 1) {
                      _dragUpdate(details.focalPoint);
                    }
                  },
                  onInteractionEnd: (ScaleEndDetails details) {
                    if (_isDragging) _dragEnd();
                  },
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
