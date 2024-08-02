import 'package:flutter/material.dart';

class BadSlideToDelete<T> extends StatelessWidget {
  /// the key of the item, used as value of [ValueKey]
  final T keyValue;

  /// try to perform delete action, return true if success, false if failed.
  /// if success, [onDismissed] will be triggered
  final Future<bool> Function() performDelete;

  /// callback when the item is dismissed, you can remove the item from the list here
  final VoidCallback onDismissed;

  /// the widget to be displayed
  final Widget child;

  const BadSlideToDelete({
    super.key,
    required this.keyValue,
    required this.performDelete,
    required this.onDismissed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(keyValue),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => performDelete(),
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
