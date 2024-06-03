import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Refresher {
  Future<void> Function()? _refresh;

  void _attach(Future<void> Function() refresh) {
    if (_refresh != null) {
      throw StateError('the instance is already attached');
    }

    _refresh = refresh;
  }

  void _detach() {
    _refresh = null;
  }

  /// reload the webview (not refresh the page)
  refresh() {
    if (_refresh == null) {
      throw StateError('the instance is not attached');
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

class BadWebview extends StatefulWidget {
  /// a extra patch for the user agent
  final String? userAgentPatch;

  /// the refresher for the webview
  final Refresher? refresher;

  /// the source of the webview
  final WebviewSource source;

  /// callback when progress changed (0.0 ~ 1.0)
  final ValueChanged<double>? onProgress;

  /// callback when web resource error occurred
  final ValueChanged<WebResourceError>? onWebResourceError;

  const BadWebview({
    super.key,
    this.userAgentPatch,
    this.refresher,
    required this.source,
    this.onProgress,
    this.onWebResourceError,
  });

  BadWebview.remote({
    super.key,
    this.refresher,
    this.userAgentPatch,
    required Uri uri,
    this.onProgress,
    this.onWebResourceError,
  }) : source = RemoteSource(uri: uri);

  BadWebview.local({
    super.key,
    this.refresher,
    this.userAgentPatch,
    required String path,
    this.onProgress,
    this.onWebResourceError,
  }) : source = LocalSource(path: path);

  @override
  State<BadWebview> createState() => _BadWebviewState();
}

class _BadWebviewState extends State<BadWebview> {
  final WebViewController controller = WebViewController();

  /// all steps here to avoid async in initState
  void setup() async {
    // config the webview
    controller
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (v) => widget.onProgress?.call(v.toDouble() / 100),
        onWebResourceError: widget.onWebResourceError,
      ));

    // patch the user agent if needed
    if (widget.userAgentPatch != null) {
      final String? ua = await controller.getUserAgent();
      await controller.setUserAgent('${ua ?? ''} ${widget.userAgentPatch}');
    }

    // attach the refresher
    widget.refresher?._attach(() => widget.source.load(controller));

    // load the source
    await widget.source.load(controller);
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  void dispose() {
    widget.refresher?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
