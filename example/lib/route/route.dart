import 'package:example/page/draft.dart';
import 'package:example/page/home.dart';
import 'package:example/page/widget/free_draw.dart';
import 'package:example/page/widget/tree.dart';
import 'package:flutter/widgets.dart';

abstract class RouteNames {
  /// draft page
  static const String draft = '/draft';

  /// entry point: gallery view
  static const String home = '/';

  static const String freeDraw = '/widget/free_draw';
  static const String tree = '/widget/tree';
}

final Map<String, WidgetBuilder> routes = {
  RouteNames.draft: (context) => const DraftPage(),
  RouteNames.home: (context) => const HomePage(),
  RouteNames.freeDraw: (context) => const FreeDrawPage(),
  RouteNames.tree: (context) => const TreePage(),
};
