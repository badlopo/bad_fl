import 'package:bad_fl/extension/list.dart';
import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

class BadPanelItem extends StatelessWidget {
  final Widget label;
  final Widget? body;
  final Widget? suffix;
  final VoidCallback? onTap;

  const BadPanelItem({
    super.key,
    required this.label,
    this.body,
    this.suffix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _BadPanelScope.of(context);
    if (scope == null) {
      throw Exception('"BadPanelItem" should be used within "BadPanel"');
    }

    final panelItem = SizedBox(
      height: scope.itemHeight,
      child: Row(
        children: [
          Expanded(child: label),
          if (body != null) Expanded(child: body!),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: suffix,
            ),
        ],
      ),
    );

    if (onTap == null) return panelItem;

    return BadClickable(onClick: onTap!, child: panelItem);
  }
}

class BadPanelOptions {
  /// title of panel, default to `null`
  final Widget? title;

  /// color of panel, default to [Colors.white]
  final Color color;

  /// border-radius of panel, default to `8`
  final double radius;

  /// thickness of divider, default to `0.5`
  final double dividerThickness;

  /// color of divider between items, default to [Colors.grey]
  final Color dividerColor;

  /// height of panel item, default to `54`
  final double itemHeight;

  const BadPanelOptions({
    this.title,
    this.color = Colors.white,
    this.radius = 8,
    this.dividerThickness = 0.5,
    this.dividerColor = Colors.grey,
    this.itemHeight = 54,
  });
}

class _BadPanelScope extends InheritedWidget {
  final double itemHeight;

  static _BadPanelScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_BadPanelScope>();
  }

  const _BadPanelScope({required super.child, required this.itemHeight});

  @override
  bool updateShouldNotify(covariant _BadPanelScope oldWidget) {
    return itemHeight == oldWidget.itemHeight;
  }
}

class BadPanel extends StatelessWidget {
  final BadPanelOptions options;
  final List<BadPanelItem> items;

  const BadPanel({
    super.key,
    this.options = const BadPanelOptions(),
    required this.items,
  }) : assert(items.length > 0, 'require at least 1 item in panel');

  @override
  Widget build(BuildContext context) {
    Widget panel = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: options.color,
        borderRadius: BorderRadius.circular(options.radius),
      ),
      child: Column(
        children: items.slotted(
          builder: (item) => item,
          slot: Divider(
            height: options.dividerThickness,
            thickness: options.dividerThickness,
            color: options.dividerColor,
          ),
        ),
      ),
    );

    if (options.title != null) {
      panel = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          options.title!,
          panel,
        ],
      );
    }

    return _BadPanelScope(
      itemHeight: options.itemHeight,
      child: panel,
    );
  }
}
