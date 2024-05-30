import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BadSnapshotController {
  final GlobalKey key = GlobalKey();

  /// capture a snapshot of the wrapped widget
  ui.Image capture([double pixelRatio = 1.0]) {
    final ctx = key.currentContext;
    if (ctx == null) {
      throw Exception(
          '"BadSnapshotController" not attached to any "BadSnapshot"');
    }

    final RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return boundary.toImageSync(pixelRatio: pixelRatio);
  }
}

/// a wrapper for capturing snapshot of its child widget
class BadSnapshot extends StatelessWidget {
  /// the controller to capture the snapshot
  final BadSnapshotController controller;

  /// the widget to capture
  final Widget child;

  const BadSnapshot({super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: controller.key, child: child);
  }
}
