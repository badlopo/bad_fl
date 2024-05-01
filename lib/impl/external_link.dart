import 'package:url_launcher/url_launcher.dart';

/// open external link
abstract class ExternalLinkImpl {
  /// open external link, the return value is as follows:
  ///
  /// - 0: success
  /// - -1: invalid url
  /// - -2: error
  ///
  /// ---
  ///
  /// known issue: always return -2 on web (https://github.com/flutter/flutter/issues/139783)
  static Future<int> openExternal(String uri) async {
    try {
      final url = Uri.tryParse(uri);
      if (url == null) return -1;

      bool r = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      return r ? 0 : -2;
    } catch (err) {
      return -3;
    }
  }
}
