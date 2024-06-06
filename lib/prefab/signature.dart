import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bad_fl/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// a layer contains a continuous stroke
class _StrokeLayer {
  final Paint paint;
  final List<Offset> points = [];

  int get pointsCount => points.length;

  _StrokeLayer(this.paint);

  void addPoint(Offset point) {
    final int len = points.length;

    // ignore the duplicated point
    if (len > 0 && points[len - 1] == point) return;

    points.add(point);
  }

  /// draw the stroke on the canvas with the given paint
  void _draw(Canvas canvas) {
    if (points.length < 2) return;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }
}

/// operation stack
class _Operations {
  /// repaint signal
  final _signal = _RepaintSignal();

  /// paint the operations on the canvas
  void _flushToCanvas() => _signal.notify();

  /// operation stack
  final List<_StrokeLayer> _stack = <_StrokeLayer>[];

  /// number of strokes in the stack
  int _layers = 0;

  /// number of layers on the canvas
  int get layerCount => _layers;

  /// number of layers in the stack (include undo layers)
  int get stackDepth => _stack.length;

  /// add a new layer to the stack, this will remove the undo layers permanently
  void _addLayer(_StrokeLayer stroke) {
    // remove the undo layers permanently
    if (_layers < _stack.length) {
      _stack.removeRange(_layers, _stack.length);
    }

    _stack.add(stroke);

    _layers += 1;
    _flushToCanvas();
  }

  /// undo the last operation
  void undo() {
    if (_layers == 0) return;

    _layers -= 1;
    _flushToCanvas();
  }

  /// redo the last undone operation
  void redo() {
    if (_layers == _stack.length) return;

    _layers += 1;
    _flushToCanvas();
  }

  /// clear the stack permanently
  ///
  /// Note: this cannot be undone
  void clear() {
    _stack.clear();

    _layers = 0;
    _flushToCanvas();
  }

  void _draw(Canvas canvas) {
    for (int i = 0; i < _layers; i++) {
      _stack[i]._draw(canvas);
    }
  }
}

class _BadSignaturePainter extends CustomPainter {
  final _Operations ops;

  _BadSignaturePainter._({required super.repaint, required this.ops});

  factory _BadSignaturePainter(_Operations operations) {
    return _BadSignaturePainter._(repaint: operations._signal, ops: operations);
  }

  @override
  void paint(Canvas canvas, _) => ops._draw(canvas);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// repaint signal
class _RepaintSignal with ChangeNotifier {
  void notify() => notifyListeners();
}

class BadSignatureController {
  final GlobalKey _key = GlobalKey(debugLabel: 'BadSignature');

  /// history stack of the operations
  final ops = _Operations();

  /// background color of the canvas
  final Color canvasColor;

  /// color of the stroke
  ///
  /// Note: the value assigned to it will take effect in the next layer
  Color strokeColor;

  /// width of the stroke
  ///
  /// Note: the value assigned to it will take effect in the next layer
  double strokeWidth;

  /// current layer of the stroke
  _StrokeLayer? _layer;

  /// id of the pointer that is currently drawing
  int? _pointerId;

  BadSignatureController({
    this.canvasColor = Colors.white,
    this.strokeColor = Colors.black,
    this.strokeWidth = 1.0,
  });

  void _addPointToLayer(Offset point) {
    // update top layer with the new point and flush to the canvas
    _layer!.addPoint(point);
    ops._flushToCanvas();
  }

  void _setupLayer(PointerDownEvent ev) {
    if (_pointerId != null) {
      BadFl.log(
        module: 'BadSignature',
        message: 'interaction pointer already exists',
      );
      return;
    }
    _pointerId = ev.pointer;

    // set up a new layer, hold its reference and add it to the stack
    _layer = _StrokeLayer(
      Paint()
        ..color = strokeColor
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    ops._addLayer(_layer!);

    BadFl.log(module: 'BadSignature', message: 'a new layer is set up');

    _addPointToLayer(ev.localPosition);
  }

  /// return `true` if layer and pointer are valid
  bool _validateLayerAndPointer(int pointer) {
    if (_layer == null) {
      BadFl.log(module: 'BadSignature', message: 'layer is not set up yet');
      return false;
    }

    if (pointer != _pointerId) {
      BadFl.log(module: 'BadSignature', message: 'not the current pointer');
      return false;
    }

    return true;
  }

  void _updateLayer(PointerMoveEvent ev) {
    if (!_validateLayerAndPointer(ev.pointer)) return;

    _addPointToLayer(ev.localPosition);
  }

  /// finish current layer and prepare for the next layer
  void _finishLayer(PointerUpEvent ev) {
    if (!_validateLayerAndPointer(ev.pointer)) return;

    _addPointToLayer(ev.localPosition);

    BadFl.log(
      module: 'BadSignature',
      message: 'layer finished with ${_layer!.pointsCount} points',
    );

    _pointerId = null;
    _layer = null;
  }

  /// export the current canvas as an image
  ui.Image toImage([double pixelRatio = 1]) {
    final ctx = _key.currentContext;
    if (ctx == null) {
      throw Exception(
          '"BadSignatureController" not attached to any "BadSignature"');
    }

    final RenderRepaintBoundary boundary =
        ctx.findRenderObject() as RenderRepaintBoundary;
    return boundary.toImageSync(pixelRatio: pixelRatio);
  }

  /// export the current canvas as a PNG and return the buffer
  Future<Uint8List> toPngBuffer([double pixelRatio = 1]) async {
    final image = toImage(pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class BadSignature extends StatefulWidget {
  final BadSignatureController controller;
  final double? width;
  final double? height;

  const BadSignature({
    super.key,
    required this.controller,
    this.width,
    this.height,
  });

  @override
  State<BadSignature> createState() => _BadSignatureState();
}

class _BadSignatureState extends State<BadSignature> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Container(
        constraints: constraints,
        decoration: BoxDecoration(color: widget.controller.canvasColor),
        clipBehavior: Clip.hardEdge,
        child: Listener(
          onPointerDown: widget.controller._setupLayer,
          onPointerMove: widget.controller._updateLayer,
          onPointerUp: widget.controller._finishLayer,
          child: RepaintBoundary(
            key: widget.controller._key,
            child: CustomPaint(
              painter: _BadSignaturePainter(widget.controller.ops),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          ),
        ),
      );
    });
  }
}
