import 'package:flutter/services.dart';

/// `impl::clipboard`: clipboard interaction
abstract class BadClipboard {
  /// read text from clipboard
  static Future<String?> readText() async {
    final t = await Clipboard.getData(Clipboard.kTextPlain);
    return t?.text;
  }

  /// write text to clipboard
  static Future<void> writeText(String content) {
    return Clipboard.setData(ClipboardData(text: content));
  }
}
