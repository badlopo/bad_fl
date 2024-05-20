import 'package:flutter/material.dart';

class BadText extends StatelessWidget {
  final String text;
  final String? fontFamily;

  /// whether the text is selectable
  ///
  /// - `false` for `BadText`
  /// - `true` for `BadText.selectable`
  final bool selectable;
  final Color? color;

  /// font size
  ///
  /// Default to `16`
  final double fontSize;

  /// font weight
  ///
  /// Default to `FontWeight.w400`
  final FontWeight fontWeight;

  /// line height
  ///
  /// Default to `fontSize * 1.2`
  final double lineHeight;

  double get height => lineHeight / fontSize;
  final bool underline;
  final bool italic;
  final List<Shadow>? shadows;
  final TextAlign textAlign;
  final TextDirection textDirection;

  final TextOverflow? overflow;
  final int? maxLines;

  /// If `overflow` is not specified, its default value depends on [maxLines]:
  ///
  /// - if [maxLines] is null, [overflow] is null
  /// - if [maxLines] is not null, [overflow] is [TextOverflow.ellipsis]
  const BadText(
    this.text, {
    super.key,
    this.fontFamily,
    this.color,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    double? lineHeight,
    this.underline = false,
    this.italic = false,
    this.shadows,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    TextOverflow? overflow,
    this.maxLines,
  })  : selectable = false,
        lineHeight = lineHeight ?? fontSize * 1.2,
        overflow =
            overflow ?? (maxLines == null ? null : TextOverflow.ellipsis);

  /// If `maxLines` is specified, the text may scroll horizontally.
  const BadText.selectable(
    this.text, {
    super.key,
    this.fontFamily,
    this.color,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    double? lineHeight,
    this.underline = false,
    this.italic = false,
    this.shadows,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    this.maxLines,
  })  : selectable = true,
        lineHeight = lineHeight ?? fontSize * 1.2,
        overflow = null;

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return SelectableText(
        text,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          height: height,
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          decorationColor: color,
          shadows: shadows,
        ),
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        height: height,
        decoration:
            underline == true ? TextDecoration.underline : TextDecoration.none,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        decorationColor: color,
        shadows: shadows,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
