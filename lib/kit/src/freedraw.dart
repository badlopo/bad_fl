import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A layer contains a continuous stroke.
class _Layer {
  final Paint paint;
  final List<Offset> points = [];

  void addPoint(Offset point) {
    final int len = points.length;

    // ignore the duplicated point
    if (len > 0 && points[len - 1] == point) return;

    points.add(point);
  }

  _Layer(this.paint);

  /// Draw the stroke on the canvas. (or a single point)
  void draw(Canvas canvas) {
    final int count = points.length;

    if (count == 0) return;

    if (count == 1) {
      canvas.drawCircle(points.first, paint.strokeWidth / 2, paint);
      return;
    }

    points.reduce((p1, p2) {
      canvas.drawLine(p1, p2, paint);
      return p2;
    });
  }
}

/// History of the operations.
class _History with ChangeNotifier {
  final List<_Layer> _layers = [];

  int _cursor = 0;

  /// Number of valid layers in the history. (exclude undone layers).
  int get count => _cursor;

  /// Number of total layers in the history. (include undone layers).
  int get total => _layers.length;

  /// the layer currently drawing
  _Layer? _layer;

  /// id of the pointer that is currently drawing
  int? _pointId;

  void _startLayer(PointerDownEvent ev, Color strokeColor, double strokeWidth) {
    if (_pointId != null) return;
    _pointId = ev.pointer;

    // drop all undone layers once a new layer is added
    if (_cursor < _layers.length) {
      _layers.removeRange(_cursor, _layers.length);
    }

    // create a new layer
    _layer = _Layer(
      Paint()
        ..color = strokeColor
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    _layers.add(_layer!);
    _cursor += 1;

    // add the first point and update canvas
    _layer!.addPoint(ev.localPosition);
    notifyListeners();
  }

  void _updateLayer(PointerMoveEvent ev) {
    if (ev.pointer != _pointId) return;

    _layer!.addPoint(ev.localPosition);
    notifyListeners();
  }

  void _finishLayer(PointerUpEvent ev) {
    if (ev.pointer != _pointId) return;

    _layer!.addPoint(ev.localPosition);
    notifyListeners();

    _layer = null;
    _pointId = null;
  }

  void _draw(Canvas canvas) {
    for (int i = 0; i < _cursor; i++) {
      _layers[i].draw(canvas);
    }
  }

  /// Undo the last operation.
  /// Do nothing if there is no operation.
  void undo() {
    if (_cursor == 0) return;

    _cursor -= 1;
    notifyListeners();
  }

  /// Undo all operations (aka clear all).
  /// Do nothing if there is no operation.
  void undoAll() {
    if (_cursor == 0) return;

    _cursor = 0;
    notifyListeners();
  }

  /// Redo the last undone operation.
  /// Do nothing if there is no undone operation.
  void redo() {
    if (_cursor == _layers.length) return;

    _cursor += 1;
    notifyListeners();
  }

  /// Redo all undone operations.
  /// Do nothing if there is no undone operation.
  void redoAll() {
    if (_cursor == _layers.length) return;

    _cursor = _layers.length;
    notifyListeners();
  }
}

/// Custom painter for free draw.
class _Painter extends CustomPainter {
  final _History history;

  _Painter(this.history) : super(repaint: history);

  @override
  void paint(Canvas canvas, _) => history._draw(canvas);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Controller for free draw widget.
class FreeDrawController {
  final GlobalKey _key = GlobalKey();
  late final _History _history;
  late final _Painter _painter;

  Color strokeColor;
  double strokeWidth;

  /// Number of valid layers in the history. (exclude undone layers).
  int get count => _history._cursor;

  /// Number of total layers in the history. (include undone layers).
  int get total => _history._layers.length;

  /// Undo the last operation.
  /// Do nothing if there is no operation.
  VoidCallback get undo => _history.undo;

  /// Undo all operations (aka clear all).
  /// Do nothing if there is no operation.
  VoidCallback get undoAll => _history.undoAll;

  /// Redo the last undone operation.
  /// Do nothing if there is no undone operation.
  VoidCallback get redo => _history.redo;

  /// Redo all undone operations.
  /// Do nothing if there is no undone operation.
  VoidCallback get redoAll => _history.redoAll;

  /// Capture the current canvas to an image.
  ui.Image toImage([double pixelRatio = 1]) {
    final ctx = _key.currentContext;
    if (ctx == null) {
      throw StateError('FreeDrawController not attached to any FreeDraw.');
    }

    final RenderRepaintBoundary boundary =
        ctx.findRenderObject() as RenderRepaintBoundary;
    return boundary.toImageSync(pixelRatio: pixelRatio);
  }

  FreeDrawController({this.strokeColor = Colors.black, this.strokeWidth = 1}) {
    _history = _History();
    _painter = _Painter(_history);
  }

  void _handlePointerDown(PointerDownEvent ev) {
    _history._startLayer(ev, strokeColor, strokeWidth);
  }

  void _handlePointerMove(PointerMoveEvent ev) {
    _history._updateLayer(ev);
  }

  void _handlePointerUp(PointerUpEvent ev) {
    _history._finishLayer(ev);
  }
}

/// A canvas for free draw with undo/redo support.
class FreeDraw extends StatefulWidget {
  final FreeDrawController controller;

  final double? width;
  final double? height;
  final Color? fill;

  const FreeDraw({
    super.key,
    required this.controller,
    this.width,
    this.height,
    this.fill,
  });

  @override
  State<FreeDraw> createState() => _FreeDrawState();
}

class _FreeDrawState extends State<FreeDraw> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          width: widget.width,
          height: widget.height,
          constraints: constraints,
          // use 'decoration' to fill the background to pass assert with 'clipBehavior'
          decoration: BoxDecoration(color: widget.fill),
          clipBehavior: Clip.hardEdge,
          child: Listener(
            onPointerDown: widget.controller._handlePointerDown,
            onPointerMove: widget.controller._handlePointerMove,
            onPointerUp: widget.controller._handlePointerUp,
            child: RepaintBoundary(
              key: widget.controller._key,
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: widget.controller._painter,
              ),
            ),
          ),
        );
      },
    );
  }
}
