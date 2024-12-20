import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A controller to capture snapshot of [SnapshotScope].
class SnapshotKit {
  final GlobalKey _key;

  SnapshotKit({String? debugLabel}) : _key = GlobalKey(debugLabel: debugLabel);

  /// Capture an image of the current state of corresponding [SnapshotScope].
  ///
  /// Example:
  /// ```dart
  /// // create a SnapshotKit instance
  /// final kit = SnapshotKit();
  /// // don't forget to attach the kit to a SnapshotScope
  /// // e.g. SnapshotScope(controller: kit, child: Text('Hello'))
  ///
  /// // capture the image and save it as png buffer
  /// final image = kit.capture();
  /// final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  /// final Uint8List buffer = byteData!.buffer.asUint8List();
  /// // do something with the buffer
  /// ```
  ui.Image capture([double pixelRatio = 1.0]) {
    final ctx = _key.currentContext;
    if (ctx == null) {
      throw StateError('SnapshotKit not attached to any SnapshotScope.');
    }

    final boundary = ctx.findRenderObject() as RenderRepaintBoundary;
    return boundary.toImageSync(pixelRatio: pixelRatio);
  }
}

/// A widget to wrap the child widget for snapshot capturing.
class SnapshotScope extends StatelessWidget {
  final SnapshotKit controller;
  final Widget child;

  const SnapshotScope({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: controller._key, child: child);
  }
}
