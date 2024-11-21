import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// App meta info management
abstract class AppMetaImpl {
  /// Operation system.
  ///
  /// Possible values include:
  /// - `android`
  /// - `fuchsia`
  /// - `ios`
  /// - `linux`
  /// - `macos`
  /// - `windows`
  static final String os = Platform.operatingSystem;

  /// Version. (e.g. `1.0.0`)
  ///
  /// Available after [prelude] is called.
  static late final String version;

  /// Build Number. (e.g. `1`)
  ///
  /// Available after [prelude] is called.
  static late final String buildNumber;

  /// A string representing the device. (e.g. `Xiaomi/Redmi Note 7`)
  static late final String device;

  /// Do prelude before available.
  ///
  /// NOTE: call this after user agreement is accepted.
  static Future<void> prelude() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      device = '${info.brand}/${info.display}';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      device = '${info.utsname.machine}/${info.systemVersion}';
    } else {
      throw UnsupportedError('Unsupported platform: $os');
    }
  }
}
