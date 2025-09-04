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

  /// NOTE: if `overflow` is not specified, its default value depends on [maxLines]:
  ///
  /// - if [maxLines] is null, [overflow] is null
  /// - if [maxLines] is not null, [overflow] is [TextOverflow.ellipsis]
  const BadKatex({
    super.key,
    this.leading,
    required this.raw,
    this.style,
    this.formulaStyle,
    this.maxLines,
    TextOverflow? overflow,
  })  : assert(leading == null || leading.length > 0, 'Think twice!'),
        assert(maxLines == null || maxLines > 0, 'Think twice!'),
        overflow =
            overflow ?? (maxLines == null ? null : TextOverflow.ellipsis);

  @override
  State<StatefulWidget> createState() => _KatexState();
}

class _KatexState extends State<BadKatex> {
  /// the content after all '\unicode' directive replaced
  String _processedRaw = '';
  List<InlineSpan> spans = [];

  void _buildSpans() {
    final formulas =
        RegExp(_formulaReg, dotAll: true).allMatches(_processedRaw);

    // if no formula is found, just return the raw text
    if (formulas.isEmpty) {
      spans = widget.leading == null
          ? []
          : [...widget.leading!, TextSpan(text: _processedRaw)];
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
        spans.add(
            TextSpan(text: _processedRaw.substring(cursor, formula.start)));
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
    if (cursor < _processedRaw.length) {
      spans.add(TextSpan(text: _processedRaw.substring(cursor)));
    }
  }

  @override
  void initState() {
    super.initState();
    _processedRaw = _convert(widget.raw);
    _buildSpans();
  }

  @override
  void didUpdateWidget(covariant BadKatex oldWidget) {
    super.didUpdateWidget(oldWidget);
    _processedRaw = _convert(widget.raw);
    _buildSpans();
  }

  @override
  Widget build(BuildContext context) {
    if (spans.isEmpty) {
      return Text(
        _processedRaw,
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
