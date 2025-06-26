import 'package:bad_fl/widgets.dart';
import 'package:example/route/route.dart';
import 'package:flutter/material.dart';

class _AsideMenuItem extends StatelessWidget {
  final String currentRoute;
  final String targetRoute;
  final String title;
  final String description;

  bool get active => currentRoute == targetRoute;

  const _AsideMenuItem({
    required this.currentRoute,
    required this.targetRoute,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: active ? Colors.blue.shade50 : Colors.white,
      ),
      child: Row(
        children: [
          active
              ? Container(
                  width: 4,
                  height: 24,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: Colors.blue,
                  ),
                )
              : const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 28, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BadText(title, fontSize: 14),
                  BadText(description, color: Colors.grey, fontSize: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return BadClickable(
      onClick: () {
        if (active) return;
        Navigator.of(context).pushReplacementNamed(targetRoute);
      },
      child: inner,
    );
  }
}

class _AppAside extends StatelessWidget {
  const _AppAside();

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.settingsOf(context)!.name ?? '';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          BadExpansible(
            headerBuilder: (controller) {
              return BadClickable(
                onClick: () => controller.toggle(),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      const Icon(Icons.widgets_outlined),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: BadText('Widgets'),
                        ),
                      ),
                      controller.isExpanded
                          ? const Icon(Icons.expand_less_outlined)
                          : const Icon(Icons.expand_more_outlined),
                    ],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                for (final route in appRoutes)
                  _AsideMenuItem(
                    currentRoute: current,
                    targetRoute: route.path,
                    title: route.names.$1,
                    description: route.names.$2,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const Drawer(child: _AppAside()),
      body: child,
    );
  }
}
