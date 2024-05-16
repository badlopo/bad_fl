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

### Extension

Extension methods of built-in types, named in the form of `<Type>Ext`.

#### [`ListExt`](./lib/extension/list.dart)

👉 `slotted`: build a new element from each element of the list and insert slot elements between every two elements.

```dart
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Text('item1'),
          Text('item2'),
          Text('item3'),
          Text('item4'),
        ].slotted(
          builder: (v) => v,
          slot: const Divider(),
        ),
      ),
    );
  }
}
```

### Fragment

Fragment is a large section of content on the interface.

#### [`BadWebviewFragment`](./lib/fragment/webview.dart)

```dart
class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<StatefulWidget> createState() => ExampleState();
}

class ExampleState extends State<Example> {
  final refresher = Refresher();
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BadText('Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refresher.refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          BadWebviewFragment.remote(
            onProgress: (v) => setState(() => progress = v),
            uri: Uri.parse('https://example.com/'),
          )
        ],
      ),
    );
  }
}
```

### Helper

#### [`BadDebouncer`](./lib/helper/debounce.dart)

```dart
void main() async {
  final debouncer = BadDebouncer(
    delay: const Duration(seconds: 1),
    defaultAction: () {
      print('default action');
    },
  );

  // 1. call the default action
  debouncer();

  // 2. call with a custom action
  await Future.delayed(const Duration(seconds: 2));
  debouncer.call(() {
    print('wrong action');
  });

  // 3. cancel the current delayed call
  debouncer.cancel();
  debouncer(() {
    print('correct action');
  });
}

// Output:
// default action
// correct action
```

#### [`BadThrottler`](./lib/helper/throttle.dart)

```dart
void main() async {
  final throttler = BadThrottler(defaultAction: () async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('default action');
  });

  // call the default action
  throttler();

  // this call will be ignored
  throttler(() async {
    print('hello');
  });

  // call with a custom action
  await Future.delayed(const Duration(seconds: 1));
  throttler(() async {
    print('hello again');
  });
}

// Output:
// default action
// hello again
```

### Impl

Some classes need to be initialized before use. Due to privacy issues, some initialization have to be done after the
user has accepted the privacy policy.

- `prepare`: can be called as soon as possible
- `extend`: may only be called after the privacy policy has been accepted

| Class              | `prepare` | `extend` |
|--------------------|-----------|----------|
| `CacheImpl`        | ✅         | ❌        |
| `ClipboardImpl`    | ❌         | ❌        |
| `EvCenterImpl`     | ❌         | ❌        |
| `ExternalLinkImpl` | ❌         | ❌        |
| `ImageOPImpl`      | ❌         | ❌        |
| `KVStorageImpl`    | ✅         | ❌        |
| `MetaImpl`         | ✅         | ✅        |
| `RequestImpl`      | ❌         | ❌        |

These classes are fully annotated, please refer to [source code](./lib/impl) for more details.

### Layout

⏳ WIP

### Mixin

⏳ WIP

### Prefab

⏳ WIP

### Wrapper

Non-visual components that wrap other components.

#### [`Clickable`](./lib/wrapper/clickable.dart)

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

## Useful Tips

- When using input components, do not use `borderRadius` and non-fully enclosed `border` at the same time. (will result
  in unexpected lines at the rounded corners)