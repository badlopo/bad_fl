import 'package:flutter/material.dart';

/// A wrapper around [Text] and [SelectableText]
/// that provides a facade configuration.
class BadText extends StatelessWidget {
  final String text;
  final String? fontFamily;

  /// Whether the text is selectable.
  ///
  /// - `false` for `BadText`
  /// - `true` for `BadText.selectable`
  final bool selectable;
  final Color? color;

  /// Default to `16`
  final double fontSize;

  /// Default to `FontWeight.w400`.
  final FontWeight fontWeight;

  /// Default to `fontSize * 1.2`.
  final double lineHeight;

  double get height => lineHeight / fontSize;
  final bool underline;
  final bool italic;
  final double letterSpacing;
  final List<Shadow>? shadows;
  final TextAlign textAlign;
  final TextDirection textDirection;

  final TextOverflow? overflow;
  final int? maxLines;

  /// NOTE: if `overflow` is not specified, its default value depends on [maxLines]:
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
    this.letterSpacing = 0.0,
    this.shadows,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    TextOverflow? overflow,
    this.maxLines,
  })  : selectable = false,
        lineHeight = lineHeight ?? fontSize * 1.2,
        overflow =
            overflow ?? (maxLines == null ? null : TextOverflow.ellipsis);

  /// NOTE: if `maxLines` is specified, the text may scroll horizontally.
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
    this.letterSpacing = 0.0,
    this.shadows,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    this.maxLines,
  })  : selectable = true,
        lineHeight = lineHeight ?? fontSize * 1.2,
        overflow = null;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      height: height,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      decorationColor: color,
      letterSpacing: letterSpacing,
      shadows: shadows,
    );

    if (selectable) {
      return SelectableText(
        text,
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
      );
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
