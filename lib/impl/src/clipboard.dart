import 'package:flutter/services.dart';

/// Clipboard interaction implementation
abstract class ClipboardImpl {
  /// Read text from clipboard
  static Future<String?> readText() async {
    final t = await Clipboard.getData(Clipboard.kTextPlain);
    return t?.text;
  }

  /// Write text to clipboard
  static Future<void> writeText(String content) {
    return Clipboard.setData(ClipboardData(text: content));
  }
}
