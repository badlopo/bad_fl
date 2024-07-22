import 'package:flutter/services.dart';

abstract class ClipboardImpl {
  static Future<String?> readText() async {
    final t = await Clipboard.getData(Clipboard.kTextPlain);
    return t?.text;
  }

  static Future<void> writeText(String content) {
    return Clipboard.setData(ClipboardData(text: content));
  }
}
