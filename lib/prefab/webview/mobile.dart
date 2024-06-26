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
  WebViewController? _wvc;
  VoidCallback? _refreshFn;

  final Set<void Function(String message)> _listeners = {};

  /// the channel name for JavaScript communication
  late final String _channel;

  /// [channelName] the channel name for JavaScript communication, must be in range of 4 to 10 characters and only alphabet
  BadWebviewController([String channelName = '@BadFL']) {
    if (channelName == '@BadFL') {
      _channel = '@BadFL';
    } else {
      if (!RegExp('^[a-zA-Z]{4,10}\$').hasMatch(channelName)) {
        throw ArgumentError(
          'channel name must be in range of 4 to 10 characters and only alphabet',
          'channelName',
        );
      }
      _channel = channelName;
    }
  }

  void _attach(WebViewController wvc, VoidCallback refreshFn) {
    _wvc = wvc;
    _refreshFn = refreshFn;

    wvc.addJavaScriptChannel(
      _channel,
      onMessageReceived: (JavaScriptMessage message) {
        for (var listener in _listeners) {
          listener(message.message);
        }
      },
    );
  }

  void _detach() {
    _wvc!.removeJavaScriptChannel(_channel);
    _wvc = null;
    _refreshFn = null;
    _listeners.clear();
  }

  void refresh() {
    if (_refreshFn == null) {
      throw StateError('the instance is not attached');
    }
    _refreshFn!();
  }

  /// add a listener to listen to the message from the webview
  ///
  /// Examples:
  ///
  /// ```js
  /// // send a message from the webview to flutter
  /// window['<your_channel_name>'].postMessage('<your_message>')
  /// ```
  void addListener(void Function(String message) listener) {
    _listeners.add(listener);
  }

  /// remove a listener
  void removeListener(void Function(String message) listener) {
    _listeners.remove(listener);
  }

  /// clear all listeners
  void clearListeners() {
    _listeners.clear();
  }

  /// send some message into the webview
  ///
  /// Example:
  ///
  /// ```js
  /// // listen to the message from flutter in the webview
  /// window.addEventListener(
  ///   '<your_channel_name>',
  ///   /**
  ///    * @param ev {CustomEvent}
  ///    */
  ///   function (ev) {
  ///     console.log('receive a message from flutter:', ev.detail)
  ///   },
  /// )
  /// ```
  void postMessage(String message) {
    if (_wvc == null) {
      throw StateError('the instance is not attached');
    }
    _wvc!.runJavaScript(
      'window.dispatchEvent(new CustomEvent("$_channel",{detail: "$message"}))',
    );
  }

  Future<void> runJavaScript(String code) {
    if (_wvc == null) {
      throw StateError('the instance is not attached');
    }
    return _wvc!.runJavaScript(code);
  }

  Future<Object> runJavaScriptReturningResult(String code) {
    if (_wvc == null) {
      throw StateError('the instance is not attached');
    }
    return _wvc!.runJavaScriptReturningResult(code);
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

    // load the source
    await loadTarget();
  }

  @override
  void initState() {
    super.initState();

    // attach the controller
    widget.controller?._attach(wvc, loadTarget);
    // setup the webview
    setup();
  }

  @override
  void dispose() {
    // detach the controller
    widget.controller?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: wvc);
  }
}
