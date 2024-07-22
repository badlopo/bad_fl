import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class MetaImpl {
  /// version (e.g. 1.0.0)
  static String _version = '??.??.??';

  static String get version => _version;

  /// buildNumber (e.g. 1)
  static String _buildNumber = '?';

  static String get buildNumber => _buildNumber;

  /// version to displayed (e.g. 1.0.0(1))
  static String get displayVersion => '$_version($_buildNumber)';

  /// os (e.g. android, fuchsia, ios, linux, macos, windows)
  static final String os = Platform.operatingSystem;

  static Future<bool> prepare() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version = info.version;
      _buildNumber = info.buildNumber;

      return true;
    } catch (_) {
      return false;
    }
  }

  /// device (e.g. Xiaomi/Redmi Note 7)
  static String _device = 'Unknown';

  static String get device => _device;

  static Future<bool> extend() async {
    try {
      final info = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final infoA = await info.androidInfo;
        _device = '${infoA.brand}/${infoA.display}';
        return true;
      } else if (Platform.isIOS) {
        final infoI = await info.iosInfo;
        _device = '${infoI.utsname.machine}/${infoI.systemVersion}';
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
