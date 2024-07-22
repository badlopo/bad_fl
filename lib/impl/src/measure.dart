import 'package:flutter/material.dart';

/// `impl::measurer`: measurer for text
abstract class BadMeasurer {
  static Size measure(
    String text, {
    TextStyle? style,
    TextDirection textDirection = TextDirection.ltr,
    double minWidth = 0.0,
    double maxWidth = double.infinity,
  }) {
    if (text.isEmpty) return Size.zero;

    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
    );
    painter.layout(minWidth: minWidth, maxWidth: maxWidth);
    return painter.size;
  }
}
