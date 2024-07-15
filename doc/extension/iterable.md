## extension -- Iterable

- [Source Code](../../lib/extension/iterable.dart)
- [GitHub Gist](https://gist.github.com/lopo12123/fa2d412f12dff1c555853c60b49ff22f)
- [Live Example](https://dartpad.dev/?id=fa2d412f12dff1c555853c60b49ff22f&run=true&channel=stable)

A method `slotted` is extended on `Iterable<T>`: build a new `List<T>` from each element of the iterable and insert slot
elements between every two elements.

Also provides a variant for `Iterable<Widget>` which can omit `builder`