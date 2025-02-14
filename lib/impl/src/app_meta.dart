import 'dart:io';

import 'package:bad_fl/core.dart';
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

  static PackageInfo? _packageInfo;

  /// Version. (e.g. `1.0.0`)
  static String get version {
    assert(_packageInfo != null, 'call "prelude" first');
    return _packageInfo!.version;
  }

  /// Build Number. (e.g. `1`)
  static String get buildNumber {
    assert(_packageInfo != null, 'call "prelude" first');
    return _packageInfo!.buildNumber;
  }

  static String? _device;

  /// A string representing the device. (e.g. `Xiaomi/Redmi Note 7`)
  static String get device {
    assert(_device != null, 'call "preludeAfterAgreed" first');
    return _device!;
  }

  /// Initialization.
  static Future<void> prelude() async {
    if (_packageInfo != null) {
      BadFl.log(
        module: 'impl/AppMetaImpl',
        message:
            'The call to "prelude" is ignored cause package info has already been initialized',
      );
      return;
    }
    _packageInfo = await PackageInfo.fromPlatform();
    BadFl.log(module: 'impl/AppMetaImpl', message: 'Package info initialized');
  }

  /// Initialization.
  ///
  /// According to privacy policy, you should call this after agreement is accepted.
  static Future<void> preludeAfterAgreed() async {
    if (_device != null) {
      BadFl.log(
        module: 'impl/AppMetaImpl',
        message:
            'The call to "preludeAfterAgreed" is ignored cause device info has already been initialized',
      );
      return;
    }

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      _device = '${info.brand}/${info.display}';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      _device = '${info.utsname.machine}/${info.systemVersion}';
    } else {
      throw UnsupportedError('Unsupported platform: $os');
    }

    BadFl.log(module: 'impl/AppMetaImpl', message: 'Device info initialized');
  }
}
