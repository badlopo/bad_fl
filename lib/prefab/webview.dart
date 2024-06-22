import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

sealed class _WebviewSource {
  const _WebviewSource();
}

class _LocalSource extends _WebviewSource {
  final String path;

  const _LocalSource({required this.path});
}

class _RemoteSource extends _WebviewSource {
  final Uri uri;

  const _RemoteSource({required this.uri});
}

class BadWebviewController {
  VoidCallback? _refreshFn;

  void refresh() {
    if (_refreshFn == null) {
      throw StateError('the instance is not attached');
    }
    _refreshFn!();
  }
}

class BadWebview extends StatefulWidget {
  final BadWebviewController? controller;

  /// build the user agent string based on the original user agent (if any)
  final String Function(String? userAgent)? userAgentBuilder;

  /// the source of the webview
  final _WebviewSource _source;

  /// callback when progress changed (0.0 ~ 1.0)
  final ValueChanged<double>? onProgress;

  /// callback when web resource error occurred
  final ValueChanged<WebResourceError>? onWebResourceError;

  BadWebview.remote({
    super.key,
    this.controller,
    this.userAgentBuilder,
    required Uri uri,
    this.onProgress,
    this.onWebResourceError,
  })  : assert(
          Platform.isAndroid || Platform.isIOS,
          'BadWebview only supports Android and iOS',
        ),
        _source = _RemoteSource(uri: uri);

  BadWebview.local({
    super.key,
    this.controller,
    this.userAgentBuilder,
    required String path,
    this.onProgress,
    this.onWebResourceError,
  })  : assert(
          Platform.isAndroid || Platform.isIOS,
          'BadWebview only supports Android and iOS',
        ),
        _source = _LocalSource(path: path);

  @override
  State<BadWebview> createState() => _BadWebviewState();
}

class _BadWebviewState extends State<BadWebview> {
  final WebViewController wvc = WebViewController();

  Future<void> loadTarget() {
    final source = widget._source;

    switch (source) {
      case _LocalSource():
        return wvc.loadFile(source.path);
      case _RemoteSource():
        return wvc.loadRequest(source.uri);
    }
  }

  /// all steps here to avoid async in initState
  void setup() async {
    // config the webview
    wvc
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (v) => widget.onProgress?.call(v.toDouble() / 100),
        onWebResourceError: widget.onWebResourceError,
      ));

    // patch the user agent if needed
    if (widget.userAgentBuilder != null) {
      final String? ua = await wvc.getUserAgent();
      await wvc.setUserAgent(widget.userAgentBuilder!(ua));
    }

    if (widget.controller != null) {
      widget.controller!._refreshFn = loadTarget;
    }

    // load the source
    await loadTarget();
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: wvc);
  }
}
