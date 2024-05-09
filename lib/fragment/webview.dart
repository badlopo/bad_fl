import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Refresher {
  Future<void> Function()? _refresh;

  /// reload the webview (not refresh the page)
  refresh() {
    if (_refresh == null) {
      throw StateError('No client attached');
    }
    _refresh!();
  }
}

// TODO: bridge (add when needed)

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

class BadWebviewFragment extends StatefulWidget {
  /// the refresher for the webview
  final Refresher? refresher;

  /// the source of the webview
  final WebviewSource source;

  /// callback when progress changed (0.0 ~ 1.0)
  final ValueChanged<double>? onProgress;

  /// callback when web resource error occurred
  final ValueChanged<WebResourceError>? onWebResourceError;

  const BadWebviewFragment.remote({
    super.key,
    this.refresher,
    required RemoteSource this.source,
    this.onProgress,
    this.onWebResourceError,
  });

  const BadWebviewFragment.local({
    super.key,
    this.refresher,
    required LocalSource this.source,
    this.onProgress,
    this.onWebResourceError,
  });

  @override
  State<BadWebviewFragment> createState() => _BadWebviewFragmentState();
}

class _BadWebviewFragmentState extends State<BadWebviewFragment> {
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

    if (widget.refresher != null) {
      widget.refresher!._refresh = () => widget.source.load(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
