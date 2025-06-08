import 'package:example/layout/app_layout.dart';
import 'package:example/page/draft.dart';
import 'package:example/page/widget/katex.dart';
import 'package:example/page/widget/shimmer.dart';
import 'package:example/page/widget/text.dart';
import 'package:example/page/widget/tree.dart';
import 'package:example/page/home.dart';
import 'package:example/page/widget/adsorb.dart';
import 'package:example/page/widget/button.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  static const home = '/';

  static const adsorb = '/widget/adsorb';
  static const button = '/widget/button';
  static const katex = '/widget/katex';
  static const shimmer = '/widget/shimmer';
  static const text = '/widget/text';
  static const tree = '/widget/tree';
}

/// display widgets for routes.
final Map<String, Widget> _widgetRoutes = {
  RouteNames.home: const HomePage(),
  RouteNames.adsorb: const AdsorbPage(),
  RouteNames.button: const ButtonPage(),
  RouteNames.katex: const KatexPage(),
  RouteNames.shimmer: const ShimmerPage(),
  RouteNames.text: const TextPage(),
  RouteNames.tree: const TreePage(),
};

Map<String, WidgetBuilder> _applyLayout(Map<String, Widget> routes) {
  return {
    for (final entry in routes.entries)
      entry.key: (context) => AppLayout(child: entry.value),
    '/draft': (_) => const DraftPage(),
  };
}

final Map<String, WidgetBuilder> appRoutes = _applyLayout(_widgetRoutes);
