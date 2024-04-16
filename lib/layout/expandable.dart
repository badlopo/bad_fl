import 'package:bad_fl/wrapper/clickable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BadExpandable extends StatelessWidget {
  /// whether the panel is open or not.
  final RxBool _open = true.obs;

  /// height of the header. default to `28.0`.
  final double headerHeight;

  /// gap between the header and the child. default to `20.0`.
  final double gap;

  /// title of the panel.
  final Widget title;

  /// icon when the panel is empty, required when [child] is `null`.
  final Widget? emptyIcon;

  /// icon when the panel is open.
  final Widget openedIcon;

  /// icon when the panel is closed.
  final Widget closedIcon;

  /// child widget to be displayed when the panel is open.
  final Widget? child;

  BadExpandable({
    super.key,
    this.headerHeight = 28.0,
    this.gap = 20.0,
    required this.title,
    this.emptyIcon,
    this.openedIcon = const Icon(Icons.arrow_drop_up, size: 24),
    this.closedIcon = const Icon(Icons.arrow_drop_down, size: 24),
    this.child,
  }) : assert(child != null || emptyIcon != null);

  @override
  Widget build(BuildContext context) {
    final header = SizedBox(
      height: headerHeight,
      child: Row(
        children: [
          Expanded(child: title),
          if (child == null)
            emptyIcon!
          else
            // this will (and only need to) be wrapped in `Obx` when `child` is not `null`.
            _open.value ? openedIcon : closedIcon,
        ],
      ),
    );

    if (child == null) return header;

    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Clickable(onClick: _open.toggle, child: header),
          if (_open.isTrue) SizedBox(height: gap),
          if (_open.isTrue) child!,
        ],
      ),
    );
  }
}
