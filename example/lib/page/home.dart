import 'package:example/route/route.dart';
import 'package:flutter/material.dart';
import 'package:bad_fl/bad_fl.dart';

class _NavItem extends StatelessWidget {
  final String name;
  final String? to;

  const _NavItem.category({required this.name}) : to = null;

  const _NavItem.item({required this.name, required String this.to});

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      height: 48,
      margin: to == null ? null : const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: to == null ? Colors.black87 : Colors.white,
        border: to == null
            ? null
            : const Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: TextStyle(color: to == null ? Colors.white : Colors.black87),
      ),
    );

    if (to == null) return inner;

    return BadClickable(
      onClick: () => Navigator.pushNamed(context, to!),
      child: inner,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BadFL'),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              // ext
              _NavItem.category(name: '扩展 (Ext)'),
              _NavItem.item(name: 'Iterable', to: RouteNames.iterable),
              _NavItem.item(name: 'num', to: RouteNames.num),
              // impl
              _NavItem.category(name: '实现 (Impl)'),
              _NavItem.item(name: 'AppMeta', to: ''),
              _NavItem.item(name: 'Clipboard', to: ''),
              _NavItem.item(name: 'EventBus', to: ''),
              _NavItem.item(name: 'FileStorage', to: ''),
              _NavItem.item(name: 'ImageIO', to: ''),
              _NavItem.item(name: 'KVStorage', to: ''),
              _NavItem.item(name: 'Launcher', to: ''),
              _NavItem.item(name: 'TextMeasure', to: ''),
              // kit
              _NavItem.category(name: '封装 (Kit)'),
              _NavItem.item(name: 'Search', to: ''),
              _NavItem.item(name: 'Snapshot', to: ''),
              // util
              _NavItem.category(name: '工具 (Util)'),
              _NavItem.item(name: 'AS-IS', to: ''),
              _NavItem.item(name: 'Version', to: ''),
              // widget
              _NavItem.category(name: '组件 (Widget)'),
              // _NavItem.item(name: 'Anchored Scrollable', to: ''),
              _NavItem.item(name: 'Button', to: ''),
              _NavItem.item(name: 'Carousel', to: ''),
              _NavItem.item(name: 'Checkbox', to: ''),
              _NavItem.item(name: 'Contribution Calendar', to: ''),
              _NavItem.item(name: 'Clickable', to: ''),
              _NavItem.item(name: 'Expandable', to: ''),
              _NavItem.item(name: 'Floating', to: ''),
              _NavItem.item(name: 'FreeDraw', to: ''),
              _NavItem.item(name: 'Input', to: ''),
              _NavItem.item(name: 'Katex', to: ''),
              _NavItem.item(name: 'NamedStack', to: ''),
              _NavItem.item(name: 'Popup', to: ''),
              _NavItem.item(name: 'Preview', to: ''),
              _NavItem.item(name: 'Radio', to: ''),
              _NavItem.item(name: 'Refreshable', to: ''),
              _NavItem.item(name: 'Switch', to: ''),
              _NavItem.item(name: 'Text', to: ''),
            ],
          ),
        ),
      ),
      body: Text('xxx'),
    );
  }
}
