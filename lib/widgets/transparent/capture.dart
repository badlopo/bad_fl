import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BadCaptureController {
  final GlobalKey _key;

  BadCaptureController({String? debugLabel})
      : _key = GlobalKey(debugLabel: debugLabel);

  /// Capture an image of the current state of corresponding [BadCapture].
  ///
  /// - [pixelRatio]: default to devicePixelRatio of MediaQuery.
  ///
  /// Example:
  /// ```dart
  /// // create a SnapshotKit instance
  /// final cc = BadCaptureController();
  /// // don't forget to attach the controller to a BadCapture
  /// // e.g. BadCapture(controller: cc, child: Text('Hello'))
  ///
  /// // capture the image and save it as png buffer
  /// final image = cc.capture();
  /// final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  /// final Uint8List buffer = byteData!.buffer.asUint8List();
  /// // do something with the buffer
  /// ```
  ui.Image capture([double? pixelRatio]) {
    final ctx = _key.currentContext;
    assert(ctx != null);

    final boundary = ctx!.findRenderObject() as RenderRepaintBoundary;
    pixelRatio ??= MediaQuery.of(ctx).devicePixelRatio;
    return boundary.toImageSync(pixelRatio: pixelRatio);
  }

  /// refer to [capture].
  Future<Uint8List> captureAsPngBytes([double? pixelRatio]) async {
    final image = capture(pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }
}

/// Wrap any widget to capture its current state as an image.
class BadCapture extends StatelessWidget {
  final BadCaptureController controller;
  final Widget child;

  const BadCapture({super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: controller._key, child: child);
  }
}
