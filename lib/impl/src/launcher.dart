import 'package:url_launcher/url_launcher_string.dart';

/// Url Launcher implementation
abstract class LauncherImpl {
  /// open link in external application (browser)
  static Future<bool> open(String uri) {
    return launchUrlString(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
}
