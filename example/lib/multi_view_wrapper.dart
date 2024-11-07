import 'dart:js_interop';
import 'dart:ui';
import 'dart:ui_web';

import 'package:flutter/widgets.dart';

/// builder function that creates flutter widget according to the initial data passed from JS.
typedef AppBuilder = Widget Function(BuildContext context, JSAny? initialData);

class MultiViewWrapper extends StatefulWidget {
  final AppBuilder appBuilder;

  const MultiViewWrapper({super.key, required this.appBuilder});

  @override
  State<MultiViewWrapper> createState() => _MultiViewWrapperState();
}

class _MultiViewWrapperState extends State<MultiViewWrapper>
    with WidgetsBindingObserver {
  /// all the views in the app now
  Map<int, Widget> _views = <int, Widget>{};

  /// create a View corresponding to the FlutterView
  View _createViewWidget(FlutterView view) {
    final JSAny? initialData = views.getInitialData(view.viewId);
    return View(
      view: view,
      child: Builder(
        builder: (context) => widget.appBuilder(context, initialData),
      ),
    );
  }

  /// update the views in the app
  _syncViews() {
    final newViews = <int, Widget>{};
    for (final view in WidgetsBinding.instance.platformDispatcher.views) {
      newViews[view.viewId] = _views[view.viewId] ?? _createViewWidget(view);
    }
    setState(() {
      _views = newViews;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // here we don't need to override didUpdateWidget cause the
  // 'MultiViewWrapper' widget is top-level and won't be updated

  @override
  void didChangeMetrics() {
    // skip the call to super.didChangeMetrics() cause it's a no-op
    // super.didChangeMetrics();

    // sync the views when the metrics change
    _syncViews();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}
