import 'package:flutter/widgets.dart';

extension IterableSlotted<Item> on Iterable<Item> {
  /// build a new `List<T>` from each element of the iterable and insert slot elements between every two elements.
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

extension IterableWidgetSlotted on Iterable<Widget> {
  /// build a new `List<Widget>` from each element of the iterable and insert slot elements between every two elements.
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

extension IterableEnumrate<T> on Iterable<T> {
  /// return a new iterator that yields the current index and the current element of the iterable.
  ///
  /// something like https://doc.rust-lang.org/std/iter/struct.Enumerate.html
  Iterable<(int, T)> get enumerate {
    int index = 0;
    return map((item) => (index++, item));
  }
}
