import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// regular expression for finding unicode directives
const String _unicodeReg =
    r'\${1,2}\\unicode\{\s*0?(?<isHex>x)?(?<val>[0-9a-fA-F]*)\s*\}\${1,2}';

/// the '\unicode{ xxx }' directive cannot be processed,
/// needs to be converted into unicode characters for display.
///
/// Rule:
/// - decimal: \unicode{ [^x][0-9a-fA-F]* }
/// - hexadecimal: \unicode{ x[0-9a-fA-F]* }
///
/// Example:
/// - \unicode{65} -> A
/// - \unicode{x41} -> A
/// - \unicode{0x41} -> A
/// - \unicode{ x41 } -> A
/// - \unicode{ 0x41 } -> A
/// - \unicode{1f600} -> 😁
String _convert(String raw) {
  final reg = RegExp(_unicodeReg, dotAll: true);

  String replaced = '';
  int p = 0;

  reg.allMatches(raw).forEach((part) {
    if (part.start > p) {
      replaced += raw.substring(p, part.start);
    }

    bool isHex = part.namedGroup('isHex') == 'x';
    int? v = int.tryParse(part.namedGroup('val') ?? '', radix: isHex ? 16 : 10);

    if (v != null) replaced += String.fromCharCode(v);

    p = part.end;
  });

  if (p < raw.length) replaced += raw.substring(p);

  return replaced;
}

/// regular expression for finding formulas in text
/// - inline formula: '$...$'
/// - block formula: '$$...$$'
const String _formulaReg =
    '((\\\$)(?<inline>[^\$]*[^\$])(\\\$)|(\\\$\\\$)(?<block>[^\$]*[^\$])(\\\$\\\$))';

/// recover the original text when an error occurs
Widget _katexErrorFallback(FlutterMathException err, TextStyle? style) {
  if (err is ParseException) {
    return Text(err.token?.text ?? '', style: style);
  }
  return const Text('');
}

/// A widget that can render text with formulas.
class BadKatex extends StatefulWidget {
  /// The leading widgets before the text.
  final Iterable<InlineSpan>? leading;

  /// The raw text that may contain formulas.
  final String raw;

  final TextStyle? style;

  /// Text style for the formula. Use [style] if not provided.
  final TextStyle? formulaStyle;

  /// Maximum number of lines for the text.
  ///
  /// Default to `null`, which means no limit.
  final int? maxLines;

  final TextOverflow? overflow;

  const BadKatex({
    super.key,
    this.leading,
    required this.raw,
    this.style,
    this.formulaStyle,
    this.maxLines,
    this.overflow,
  })  : assert(leading == null || leading.length > 0, 'Think twice!'),
        assert(maxLines == null || maxLines > 0, 'Think twice!');

  @override
  State<StatefulWidget> createState() => _BadKatexState();
}

class _BadKatexState extends State<BadKatex> {
  List<InlineSpan> spans = [];

  void _buildSpans() {
    final raw = _convert(widget.raw);
    final formulas = RegExp(_formulaReg, dotAll: true).allMatches(raw);

    // if no formula is found, just return the raw text
    if (formulas.isEmpty) {
      spans = widget.leading == null
          ? []
          : [...widget.leading!, TextSpan(text: raw)];
      return;
    }

    // reset the spans
    spans = [...?widget.leading];
    final appliedStyle = widget.formulaStyle ?? widget.style;

    // a cursor to track the position of the text
    int cursor = 0;

    for (final formula in formulas) {
      // leading text before the first formula
      if (formula.start > cursor) {
        spans.add(TextSpan(text: raw.substring(cursor, formula.start)));
      }

      final inline = formula.namedGroup('inline');
      if (inline != null) {
        // inline formula: '$...$'
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              inline,
              textStyle: appliedStyle,
              mathStyle: MathStyle.text,
              onErrorFallback: (e) => _katexErrorFallback(e, appliedStyle),
            ),
          ),
        );
      } else {
        // block formula: '$$...$$'
        final block = formula.namedGroup('block')!;
        spans.addAll([
          const TextSpan(text: '\n'),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Center(
              child: Math.tex(
                block,
                textStyle: appliedStyle,
                mathStyle: MathStyle.display,
                onErrorFallback: (e) => _katexErrorFallback(e, appliedStyle),
              ),
            ),
          ),
          const TextSpan(text: '\n'),
        ]);
      }

      // update the cursor
      cursor = formula.end;
    }

    // trailing text after the last formula
    if (cursor < raw.length) {
      spans.add(TextSpan(text: raw.substring(cursor)));
    }
  }

  @override
  void initState() {
    super.initState();
    _buildSpans();
  }

  @override
  void didUpdateWidget(covariant BadKatex oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildSpans();
  }

  @override
  Widget build(BuildContext context) {
    if (spans.isEmpty) {
      return Text(
        widget.raw,
        style: widget.style,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      style: widget.style,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
