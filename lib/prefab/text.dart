import 'package:flutter/material.dart';

/// 支持的字体列表
abstract class FontList {
  /// PingFang SC -- 默认
  static const String pingFang = 'PingFang SC';

  /// JinBu -- 广告卡片
  static const String jinBu = 'JinBu';

  /// Merriweather -- 文献标题
  static const String merriweather = 'Merriweather';

  /// Roboto -- 数据行文本 (日期, 热度, 数量, 等)
  static const String roboto = 'Roboto';

  /// DIN -- 支付相关
  static const String din = 'DIN';
}

const _error1 = '[TextImpl] overflow does not work with selectable!';
const _error2 =
    '[TextImpl] use maxLines with selectable text may cause unexpected scroll!';

class BadText extends StatelessWidget {
  final String text;
  final String? fontFamily;

  /// 是否可选中, 默认 false
  final bool selectable;
  final Color? color;

  /// 字体大小, 默认 16
  final double fontSize;

  /// 字体粗细, 默认 w400
  final FontWeight fontWeight;

  /// 行高, 使用具体数值, 默认 1.2 * 16 = 19.2
  final double lineHeight;

  double get height => lineHeight / fontSize;
  final bool? underline;
  final List<Shadow>? shadows;
  final TextAlign? textAlign;
  final TextDirection? textDirection;

  /// Note: does not work with selectable
  final TextOverflow? overflow;
  final int? maxLines;

  const BadText(
    this.text, {
    super.key,
    this.fontFamily,
    this.selectable = false,
    this.color,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    double? lineHeight,
    this.underline,
    this.shadows,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  }) : lineHeight = lineHeight ?? fontSize * 1.2;

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      if (overflow != null) {
        throw Exception(_error1);
      }
      if (maxLines != null) {
        throw Exception(_error2);
      }

      return SelectableText(
        text,
        // disable magnifier
        magnifierConfiguration: TextMagnifierConfiguration.disabled,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          height: height,
          decoration: underline == true
              ? TextDecoration.underline
              : TextDecoration.none,
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
        shadows: shadows,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
