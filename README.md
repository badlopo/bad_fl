# BadFL

[![Pub Version](https://img.shields.io/pub/v/bad_fl)](https://github.com/badlopo/bad_fl)

A flutter package, including components, implementations, helper functions and extensions. Designed to provide a simple
way to develop with flutter.

## Overview

The [`bad_fl`](https://pub.dev/packages/bad_fl) expresses component properties in a form closer to CSS representation,
making it easier for web developers to get started.

**NOTE:** This library **completely** abandons semantics! (For example, `Container`+`GestureDetector` is used to
express a `Button` rather than build-in ones) People who have related needs or care about this should use it with
caution.

## Usage

## Extension

Extension methods of built-in types, named in the form of `<Type>Ext`.

### [`ListExt`](./lib/extension/list.dart)

- `slotted`: build a new element from each element of the list and insert slot elements between every two elements.

## Fragment

⏳ WIP

## Helper

### [`BadDebouncer`](./lib/helper/debounce.dart)

⏳ WIP

### [`BadThrottler`](./lib/helper/throttle.dart)

⏳ WIP

## Impl

Some classes need to be initialized before use. Due to privacy issues, some initialization have to be done after the
user has accepted the privacy policy.

- `prepare`: can be called as soon as possible
- `extend`: may only be called after the privacy policy has been accepted

Below is a list of classes that need to be initialized:

| Class             | `prepare` | `extend` |
|-------------------|-----------|----------|
| `CacheImpl`       | ✅         | ❌        |
| `ClipboardImpl`   | ❌         | ❌        |
| `EvCenterImpl`    | ❌         | ❌        |
| `ImageSelectImpl` | ❌         | ❌        |
| `KVStorageImpl`   | ✅         | ❌        |
| `MetaImpl`        | ✅         | ✅        |
| `RequestImpl`     | ❌         | ❌        |

⏳ WIP

## Layout

⏳ WIP

## Mixin

⏳ WIP

## Prefab

⏳ WIP

## Wrapper

Non-visual components that wrap other components.

### [`Clickable`](./lib/wrapper/clickable.dart)

Add click event listener to the widget.

```dart
class ClickableExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Clickable(
      onClick: () => print('clicked'),
      child: Container(width: 100, height: 100, color: Colors.blue),
    );
  }
}
```

# Useful Tips

- When using input components, do not use `borderRadius` and non-fully enclosed `border` at the same time. (will result
  in unexpected lines at the rounded corners)