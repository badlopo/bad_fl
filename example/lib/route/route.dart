import 'package:example/page/draft.dart';
import 'package:example/page/home.dart';
import 'package:example/page/widget/button.dart';
import 'package:flutter/material.dart';

part 'layout.dart';

abstract class RouteNames {
  /// ::home
  static const home = '/';

  /// ::draft
  static const draft = '/draft';

  /// widget::button
  static const button = '/widget/button';
}

/// display names for routes.
final Map<String, String> routeNames = {
  RouteNames.home: 'Home',
  RouteNames.draft: 'Draft',
  RouteNames.button: 'Button',
};

/// display widgets for routes.
final Map<String, Widget> routeWidgets = {
  RouteNames.home: const HomePage(),
  RouteNames.draft: const DraftPage(),
  RouteNames.button: const ButtonPage(),
};

Map<String, WidgetBuilder> _applyLayout(Map<String, Widget> routes) {
  return {
    for (final entry in routes.entries)
      // entry.key: (context) => entry.value,
      entry.key: (context) => AppLayout(child: entry.value),
  };
}

final Map<String, WidgetBuilder> appRoutes = _applyLayout(routeWidgets);
