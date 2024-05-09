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

  const BadWebviewFragment.remote({
    super.key,
    this.refresher,
    this.userAgentPatch,
    required RemoteSource this.source,
    this.onProgress,
    this.onWebResourceError,
  });

  const BadWebviewFragment.local({
    super.key,
    this.userAgentPatch,
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

    // load the source
    widget.source.load(controller);

    // update the refresher
    if (widget.refresher != null) {
      widget.refresher!._refresh = () => widget.source.load(controller);
    }
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
