import 'package:example/page/draft.dart';
import 'package:example/page/ext/iterable.dart';
import 'package:example/page/ext/num.dart';
import 'package:example/page/home.dart';
import 'package:flutter/widgets.dart';

abstract class RouteNames {
  /// draft page
  static const String draft = '/draft';

  /// entry point: gallery view
  static const String home = '/';

  /// Ext::Iterable
  static const String iterable = '/ext/iterable';

  /// Ext::num
  static const String num = '/ext/num';
}

final Map<String, WidgetBuilder> routes = {
  RouteNames.draft: (context) => const DraftPage(),
  RouteNames.home: (context) => const HomePage(),
  // ext
  RouteNames.iterable: (_) => const IterablePage(),
  RouteNames.num: (_) => const NumPage(),
};
