## extension/iterable

- [Source Code](../../lib/extension/src/iterable.dart)
- [GitHub Gist](https://gist.github.com/lopo12123/fa2d412f12dff1c555853c60b49ff22f)
- [Live Example](https://dartpad.dev/?id=fa2d412f12dff1c555853c60b49ff22f&run=true&channel=stable)

## Methods & Properties

### slotted

```dart
List<Product> slotted<Product>({
  required Product Function(Item item) builder,
  required Product slot,
})
```

build a new `List<T>` from each element of the iterable and insert slot elements between every two elements.

```dart
Widget asIs(Widget it) => it;

List<Widget> slotted({
  Widget Function(Widget item) builder = asIs,
  required Widget slot,
})
```

similar to `slotted` but for `Widget` with default `asIs` builder.
