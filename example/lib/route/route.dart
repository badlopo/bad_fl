import 'package:example/layout/app_layout.dart';
import 'package:example/page/home.dart';
import 'package:example/page/widget/visual/button.dart';
import 'package:example/page/widget/visual/katex.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  static const home = '/';

  static const button = '/widget/visual/button';
  static const katex = '/widget/visual/katex';
  static const shimmer = '/widget/visual/shimmer';
  static const text = '/widget/visual/text';
}

/// display widgets for routes.
final Map<String, Widget> _widgetRoutes = {
  RouteNames.home: const HomePage(),
  RouteNames.button: const ButtonPage(),
  RouteNames.katex: const KatexPage(),
};

Map<String, WidgetBuilder> _applyLayout(Map<String, Widget> routes) {
  return {
    for (final entry in routes.entries)
      entry.key: (context) => AppLayout(child: entry.value),
  };
}

final Map<String, WidgetBuilder> appRoutes = _applyLayout(_widgetRoutes);
