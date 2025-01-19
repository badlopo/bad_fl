import 'package:flutter/cupertino.dart';

abstract class Styles {
  static const h1 = TextStyle(
    fontSize: 24,
    height: 1.6,
    fontWeight: FontWeight.w700,
  );

  static const p = TextStyle(
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const code = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontFamily: 'JetBrains Mono',
  );
}
