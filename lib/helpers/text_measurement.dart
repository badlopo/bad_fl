import 'package:flutter/painting.dart';

/// Measure the size of the text with the given configuration.
Size measureText(
  String text, {
  TextStyle? style,
  TextDirection textDirection = TextDirection.ltr,
  double minWidth = 0.0,
  double maxWidth = double.infinity,
}) {
  // obviously, empty text always has zero size
  if (text.isEmpty) return Size.zero;

  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
  );
  painter.layout(minWidth: minWidth, maxWidth: maxWidth);

  return painter.size;
}
