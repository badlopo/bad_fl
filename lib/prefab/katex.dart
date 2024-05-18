import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// the '\unicode{ xxx }' directive cannot be processed,
/// needs to be converted into unicode characters for display.
///
/// Rules:
/// - decimal: \unicode{ [^x][0-9a-zA-Z]* }
/// - hexadecimal: \unicode{ x[0-9a-zA-Z]* }
String _convert(String raw) {
  var reg = RegExp(
    r'\${1,2}\\unicode\{(?<isHex>x)?(?<val>[0-9a-eA-E]*)\}\${1,2}',
    dotAll: true,
  );

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

/// find all formulas in the text using regular expressions
Iterable<RegExpMatch> _find(String str) {
  const String reg =
      '((\\\$)([^\$]*[^\$])(\\\$)|(\\\$\\\$)([^\$]*[^\$])(\\\$\\\$))';

  return RegExp(reg, dotAll: true).allMatches(str);
}

/// recover the original text when an error occurs
Widget _recover(FlutterMathException err, [TextStyle? style]) {
  if (err is ParseException) {
    return Text(err.token?.text ?? '', style: style);
  }
  return Text('', style: style);
}

class BadKatex extends StatelessWidget {
  /// the string obtained after replacing unicode with the original text
  final String text;

  /// prefix elements
  final List<InlineSpan>? prefixes;

  /// text style for the text
  final TextStyle? style;

  /// text style for the formula
  ///
  /// this will override the [style] for the formula (using `style.merge(formulaStyle)`)
  ///
  /// Default to [style]
  final TextStyle? formulaStyle;

  /// max number of lines
  ///
  /// Default is null, which means no limit
  final int? maxLines;

  final TextOverflow? overflow;

  BadKatex({
    super.key,
    required String raw,
    this.prefixes,
    this.style,
    TextStyle? formulaStyle,
    this.maxLines,
    TextOverflow? overflow,
  })  : assert(
          maxLines == null || maxLines > 0,
          'maxLines must be greater than 0 if it is not null',
        ),
        assert(
          prefixes == null || prefixes.isNotEmpty,
          'prefixes cannot be empty if it is not null',
        ),
        text = _convert(raw),
        formulaStyle = style == null ? formulaStyle : style.merge(formulaStyle),
        overflow =
            overflow ?? (maxLines == null ? null : TextOverflow.ellipsis);

  @override
  Widget build(BuildContext context) {
    final Iterable<RegExpMatch> segments = _find(text);

    if (segments.isEmpty) {
      if (prefixes == null) {
        return Text(text, style: style, maxLines: maxLines, overflow: overflow);
      } else {
        return Text.rich(
          TextSpan(children: [...prefixes!, TextSpan(text: text)]),
          style: style,
          maxLines: maxLines,
          overflow: overflow,
        );
      }
    }

    List<InlineSpan> parts = [...?prefixes];
    int ptr = 0;

    for (RegExpMatch segment in segments) {
      // add the skipped text as a text span
      if (segment.start > ptr) {
        parts.add(TextSpan(text: text.substring(ptr, segment.start)));
      }

      if (segment.group(3) != null) {
        // inline: $xxx$ (substring: start+1, end-1)
        final expr = text.substring(segment.start + 1, segment.end - 1);
        parts.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Math.tex(
            expr,
            textStyle: formulaStyle,
            mathStyle: MathStyle.text,
            onErrorFallback: (e) => _recover(e, style),
          ),
        ));
      } else {
        // block: $$xxx$$ (substring: start+2, end-2)
        final expr = text.substring(segment.start + 2, segment.end - 2);
        parts.addAll([
          const TextSpan(text: '\n'),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Center(
              child: Math.tex(
                expr,
                textStyle: formulaStyle,
                onErrorFallback: (e) => _recover(e, style),
              ),
            ),
          ),
          const TextSpan(text: '\n'),
        ]);
      }

      // update the pointer
      ptr = segment.end;
    }

    // add the remaining text as a text span
    if (ptr < text.length) {
      parts.add(TextSpan(text: text.substring(ptr)));
    }

    return Text.rich(
      TextSpan(children: parts),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
