# extension/iterable

- [Source Code](../../lib/extension/src/iterable.dart)
- [GitHub Gist](https://gist.github.com/lopo12123/fa2d412f12dff1c555853c60b49ff22f)
- [Live Example](https://dartpad.dev/?id=fa2d412f12dff1c555853c60b49ff22f&run=true&channel=stable)

## Methods & Properties

### slotted

build a new `List<T>` from each element of the iterable and insert slot elements between every two elements.

> For `List<Widget>`, builder can be omitted (there is a default asIs implementation)

### enumerate

> something like https://doc.rust-lang.org/std/iter/struct.Enumerate.html

return a new iterator that yields the current index and the current element of the iterable.
