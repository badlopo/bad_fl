import 'package:bad_fl/bad_fl.dart';
import 'package:example/page/draft.dart';
import 'package:example/page/experimental/adsorb.dart';
import 'package:example/page/experimental/named_stack.dart';
import 'package:example/page/widget/anchored_scrollable.dart';
import 'package:example/page/widget/expansible.dart';
import 'package:example/page/widget/katex.dart';
import 'package:example/page/widget/popup.dart';
import 'package:example/page/widget/preview.dart';
import 'package:example/page/widget/shimmer.dart';
import 'package:example/page/widget/spinner.dart';
import 'package:example/page/widget/switch.dart';
import 'package:example/page/widget/text.dart';
import 'package:example/page/widget/tree.dart';
import 'package:example/page/widget/button.dart';
import 'package:flutter/material.dart';

part 'app_layout.dart';

sealed class AsideMenuItem {
  const AsideMenuItem();
}

class AsideMenuGroup extends AsideMenuItem {
  final String name;

  const AsideMenuGroup(this.name);
}

class AsideMenuSubtitle extends AsideMenuItem {
  final String name;

  const AsideMenuSubtitle(this.name);
}

class AsideMenuRoute extends AsideMenuItem {
  final String path;
  final Widget page;
  final ({String en, String zh}) names;

  const AsideMenuRoute({
    required this.path,
    required this.page,
    required this.names,
  });
}

const firstRoute = '/widget/anchored_scrollable';

const menuItems = [
  AsideMenuGroup('Widget'),
  AsideMenuSubtitle('Transparent'),
  AsideMenuRoute(
    path: '/widget/anchored_scrollable',
    page: AnchoredScrollablePage(),
    names: (en: 'AnchoredScrollable', zh: '锚点滚动'),
  ),
  AsideMenuRoute(
    path: '/widget/expansible',
    page: ExpansiblePage(),
    names: (en: 'Expansible', zh: '展开'),
  ),
  AsideMenuRoute(
    path: '/widget/popup',
    page: PopupPage(),
    names: (en: 'Popup', zh: '弹出'),
  ),
  AsideMenuRoute(
    path: '/widget/preview',
    page: PreviewPage(),
    names: (en: 'Preview', zh: '预览'),
  ),
  AsideMenuRoute(
    path: '/widget/spinner',
    page: SpinnerPage(),
    names: (en: 'Spinner', zh: '旋转'),
  ),
  AsideMenuRoute(
    path: '/widget/tree',
    page: TreePage(),
    names: (en: 'Tree', zh: '树'),
  ),
  AsideMenuSubtitle('Visual'),
  AsideMenuRoute(
    path: '/widget/button',
    page: ButtonPage(),
    names: (en: 'Button', zh: '按钮'),
  ),
  AsideMenuRoute(
    path: '/widget/katex',
    page: KatexPage(),
    names: (en: 'Katex', zh: '公式'),
  ),
  AsideMenuRoute(
    path: '/widget/shimmer',
    page: ShimmerPage(),
    names: (en: 'Shimmer', zh: '闪光'),
  ),
  AsideMenuRoute(
    path: '/widget/text',
    page: TextPage(),
    names: (en: 'Text', zh: '文本'),
  ),
  AsideMenuSubtitle('Prefab'),
  AsideMenuRoute(
    path: '/widget/switch',
    page: SwitchPage(),
    names: (en: 'Switch', zh: '开关'),
  ),
  AsideMenuGroup('Experimental'),
  AsideMenuRoute(
    path: '/widget/adsorb',
    page: AdsorbPage(),
    names: (en: 'Adsorb', zh: '吸附'),
  ),
  AsideMenuRoute(
    path: '/widget/named_stack',
    page: NamedStackPage(),
    names: (en: 'NamedStack', zh: '命名堆叠'),
  ),
];

final Map<String, WidgetBuilder> appRouter = {
  for (final item in menuItems)
    if (item is AsideMenuRoute)
      item.path: (context) => AppLayout(names: item.names, child: item.page),
  '/draft': (_) => const DraftPage(),
};
