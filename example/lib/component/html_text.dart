import 'package:flutter/material.dart';

class HtmlText extends StatelessWidget {
  static const _h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const _h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const _h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const _p = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.2,
  );

  final TextStyle _style;
  final String text;

  const HtmlText.h1(this.text, {super.key}) : _style = _h1;

  const HtmlText.h2(this.text, {super.key}) : _style = _h2;

  const HtmlText.h3(this.text, {super.key}) : _style = _h3;

  const HtmlText.p(this.text, {super.key}) : _style = _p;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: _style),
    );
  }
}
