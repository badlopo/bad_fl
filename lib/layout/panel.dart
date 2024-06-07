import 'package:bad_fl/extension/Iterable.dart';
import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';

class BadPanelItem extends StatelessWidget {
  /// label widget
  final Widget label;

  /// body widget, `null` if no body
  final Widget? body;

  /// suffix widget, `null` if no suffix
  final Widget? suffix;

  /// callback when item is clicked, `null` if not clickable
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
    final scope = _BadPanelProvider.of(context);
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
            Padding(padding: const EdgeInsets.only(left: 4), child: suffix),
        ],
      ),
    );

    if (onTap == null) return panelItem;

    return BadClickable(onClick: onTap!, child: panelItem);
  }
}

class BadPanelOptions {
  /// background color of panel
  ///
  /// Default to `Colors.white`
  final Color fill;

  /// border radius of panel
  ///
  /// Default to `8`
  final double borderRadius;

  /// divider between items
  ///
  /// Default to `Divider(height: 0.5, thickness: 0.5, color: Colors.grey)`
  final Widget? divider;

  /// height of each item
  ///
  /// Default to `54`
  final double itemHeight;

  const BadPanelOptions({
    this.fill = Colors.white,
    this.borderRadius = 8,
    this.itemHeight = 54,
    this.divider = const Divider(
      height: 0.5,
      thickness: 0.5,
      color: Colors.grey,
    ),
  });
}

class _BadPanelProvider extends InheritedWidget {
  static _BadPanelProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_BadPanelProvider>();
  }

  final double itemHeight;

  const _BadPanelProvider({required super.child, required this.itemHeight});

  @override
  bool updateShouldNotify(covariant _BadPanelProvider oldWidget) {
    return itemHeight == oldWidget.itemHeight;
  }
}

class BadPanel extends StatelessWidget {
  /// options of the panel
  final BadPanelOptions options;

  /// title widget, `null` if no title
  final Widget? title;

  /// items in panel
  final List<BadPanelItem> items;

  const BadPanel({
    super.key,
    this.options = const BadPanelOptions(),
    this.title,
    required this.items,
  }) : assert(items.length > 0, 'require at least 1 item in panel');

  @override
  Widget build(BuildContext context) {
    List<Widget> children = options.divider == null
        ? items
        : items.slotted(builder: (item) => item, slot: options.divider!);

    Widget panel = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: options.fill,
        borderRadius: BorderRadius.circular(options.borderRadius),
      ),
      child: Column(children: children),
    );

    if (title != null) {
      panel = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title!, panel],
      );
    }

    return _BadPanelProvider(itemHeight: options.itemHeight, child: panel);
  }
}
