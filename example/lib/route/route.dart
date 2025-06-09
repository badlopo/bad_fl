import 'package:example/layout/app_layout.dart';
import 'package:example/page/draft.dart';
import 'package:example/page/widget/katex.dart';
import 'package:example/page/widget/preview.dart';
import 'package:example/page/widget/shimmer.dart';
import 'package:example/page/widget/text.dart';
import 'package:example/page/widget/tree.dart';
import 'package:example/page/widget/adsorb.dart';
import 'package:example/page/widget/button.dart';
import 'package:flutter/material.dart';

class RouteObject {
  final String path;
  final Widget page;
  final (String, String) names;

  const RouteObject({
    required this.path,
    required this.page,
    required this.names,
  });
}

const appRoutes = [
  RouteObject(
    path: '/widget/adsorb',
    page: AdsorbPage(),
    names: ('Adsorb', '吸附'),
  ),
  RouteObject(
    path: '/widget/button',
    page: ButtonPage(),
    names: ('Button', '按钮'),
  ),
  RouteObject(
    path: '/widget/katex',
    page: KatexPage(),
    names: ('Katex', '公式'),
  ),
  RouteObject(
    path: '/widget/preview',
    page: PreviewPage(),
    names: ('Preview', '预览'),
  ),
  RouteObject(
    path: '/widget/shimmer',
    page: ShimmerPage(),
    names: ('Shimmer', '闪光'),
  ),
  RouteObject(
    path: '/widget/text',
    page: TextPage(),
    names: ('Text', '文本'),
  ),
  RouteObject(
    path: '/widget/tree',
    page: TreePage(),
    names: ('Tree', '树'),
  ),
];

final Map<String, WidgetBuilder> appRouter = {
  for (final route in appRoutes)
    route.path: (context) => AppLayout(child: route.page),
  '/draft': (_) => const DraftPage(),
};
