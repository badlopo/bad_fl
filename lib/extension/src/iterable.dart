import 'package:flutter/widgets.dart';

extension IterableExt<Item> on Iterable<Item> {
  List<Product> slotted<Product>({
    required Product Function(Item item) builder,
    required Product slot,
  }) {
    final result = <Product>[];
    bool skip = true;
    for (Item item in this) {
      if (skip) {
        skip = false;
      } else {
        result.add(slot);
      }
      result.add(builder(item));
    }
    return result;
  }
}

Widget asIs(Widget it) => it;

extension IterableWidgetExt on Iterable<Widget> {
  List<Widget> slotted({
    Widget Function(Widget item) builder = asIs,
    required Widget slot,
  }) {
    final result = <Widget>[];
    bool skip = true;
    for (Widget item in this) {
      if (skip) {
        skip = false;
      } else {
        result.add(slot);
      }
      result.add(builder(item));
    }
    return result;
  }
}
