import 'package:flutter/material.dart';

class BadSwipeDismiss<T> extends StatelessWidget {
  /// the key of the item, used as value of [ValueKey]
  final T keyValue;

  /// callback to check if the item can be dismissed
  /// - if true, the [onDismissed] will be called
  /// - if false, the item will be restored to its original position
  final Future<bool> Function() canDismiss;

  /// callback when the item is dismissed, you can remove the item from the list here
  final VoidCallback onDismissed;

  /// the widget to be displayed
  final Widget child;

  const BadSwipeDismiss({
    super.key,
    required this.keyValue,
    required this.canDismiss,
    required this.onDismissed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(keyValue),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => canDismiss(),
      onDismissed: (_) => onDismissed(),
      background: Container(
        color: Colors.red,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, size: 24, color: Colors.white),
            SizedBox(width: 24),
          ],
        ),
      ),
      child: child,
    );
  }
}
