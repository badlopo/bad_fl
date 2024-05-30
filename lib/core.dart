import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class _BadFlCore {
  bool enableLog = kDebugMode;

  void log({required String module, required String message}) {
    if (enableLog) developer.log('Module <$module>: $message', name: 'BadFL');
  }
}

// ignore: non_constant_identifier_names
final BadFl = _BadFlCore();
