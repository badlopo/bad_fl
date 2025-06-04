import 'package:bad_fl/bad_fl.dart';
import 'package:example/page/draft.dart';
import 'package:example/page/home.dart';
import 'package:example/page/widget/visual/button.dart';
import 'package:example/page/widget/visual/katex.dart';
import 'package:flutter/material.dart';

part 'layout.dart';

abstract class RouteNames {
  /// ::home
  static const home = '/';

  /// ::widget::visual::button
  static const button = '/widget/visual/button';

  /// ::widget::visual::katex
  static const katex = '/widget/visual/katex';
}

/// display widgets for routes.
final Map<String, Widget> routeWidgets = {
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

final Map<String, WidgetBuilder> appRoutes = _applyLayout(routeWidgets);
