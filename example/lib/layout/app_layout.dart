import 'dart:js' as js show context;

import 'package:bad_fl/widgets.dart';
import 'package:example/route/route.dart';
import 'package:flutter/material.dart';

class _HtmlAnchor extends StatelessWidget {
  final String target;
  final Widget child;

  const _HtmlAnchor({required this.target, required this.child});

  @override
  Widget build(BuildContext context) {
    return BadClickable(
      onClick: () {
        js.context.callMethod('open', [target]);
      },
      child: child,
    );
  }
}

class _AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: const Row(
        children: [
          BadText('BadFL'),
          Spacer(),
          _HtmlAnchor(
            target: 'https://github.com/badlopo/bad_fl/tree/master/example',
            child: Tooltip(
              message: 'Source Code',
              child: Icon(Icons.code_outlined),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

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

    return ListView(
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
    );
  }
}

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppHeader(),
      body: Row(
        children: [
          const SizedBox(width: 240, child: _AppAside()),
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),
          Expanded(child: child),
        ],
      ),
    );
  }
}
