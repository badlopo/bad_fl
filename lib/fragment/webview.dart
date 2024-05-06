import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

sealed class WebviewSource {
  const WebviewSource();

  Future<void> load(WebViewController controller);
}

class LocalSource extends WebviewSource {
  final String path;

  const LocalSource({required this.path});

  @override
  Future<void> load(WebViewController controller) {
    return controller.loadFile(path);
  }
}

class RemoteSource extends WebviewSource {
  final Uri uri;

  const RemoteSource({required this.uri});

  @override
  Future<void> load(WebViewController controller) {
    return controller.loadRequest(uri);
  }
}

class WebviewFragment extends StatefulWidget {
  /// the source of the webview
  final WebviewSource source;

  /// callback when progress changed (0.0 ~ 1.0)
  final ValueChanged<double>? onProgress;

  /// callback when web resource error occurred
  final ValueChanged<WebResourceError>? onWebResourceError;

  const WebviewFragment.remote({
    super.key,
    required RemoteSource this.source,
    this.onProgress,
    this.onWebResourceError,
  });

  const WebviewFragment.local({
    super.key,
    required LocalSource this.source,
    this.onProgress,
    this.onWebResourceError,
  });

  @override
  State<WebviewFragment> createState() => _WebviewFragmentState();
}

class _WebviewFragmentState extends State<WebviewFragment> {
  final WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();

    // config the webview
    controller
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (v) => widget.onProgress?.call(v.toDouble() / 100),
        onWebResourceError: widget.onWebResourceError,
      ));

    // load the source
    widget.source.load(controller);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
