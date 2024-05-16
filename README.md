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

#### ListExt

[source code](./lib/extension/list.dart)

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

#### BadWebviewFragment

[source code](./lib/fragment/webview.dart)

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

#### BadDebouncer

[source code](./lib/helper/debounce.dart)

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

#### BadThrottler

[source code](./lib/helper/throttle.dart)

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

These classes are fully annotated, please refer to [source code](./lib/impl) for more details.

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

### Layout

⏳ WIP

### Mixin

⏳ WIP

### Prefab

#### BadButton

[source code](./lib/prefab/button.dart)

| Property       | Type           | Default | Description                        |
|----------------|----------------|---------|------------------------------------|
| `width`        | `double?`      | -       | The width of the button            |
| `height`       | `double`       | -       | The height of the button           |
| `margin`       | `EdgeInsets?`  | -       | The margin of the button           |
| `padding`      | `EdgeInsets?`  | -       | The padding of the button          |
| `border`       | `Border?`      | -       | The border of the button           |
| `borderRadius` | `double`       | `0`     | The border radius of the button    |
| `fill`         | `Color?`       | -       | The background color of the button |
| `child`        | `Widget`       | -       | The child widget of the button     |
| `onClick`      | `VoidCallback` | -       | The click callback of the button   |

### Wrapper

Non-visual components that wrap other components.

#### BadClickable

[source code](./lib/wrapper/clickable.dart)

Add click event listener for the widget.

```dart
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BadClickable(
        onClick: () => print('clicked'),
        child: Container(width: 100, height: 100, color: Colors.blue),
      ),
    );
  }
}
```

#### BadHeroPreviewer

[source code](./lib/wrapper/hero_previewer.dart)

Provide a preview view for the component, with hero animation when opening the preview view.

- image preview:

![](./media/hero_previewer_image.gif)

```dart
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          crossAxisCount: 3,
        ),
        itemCount: 15,
        itemBuilder: (_, int index) {
          return BadHeroPreviewer(
            displayWidget: Image.network(
              'https://picsum.photos/seed/num-$index/200',
              width: 50,
            ),
          );
        },
      ),
    );
  }
}
```

- custom widget:

![](./media/hero_previewer_custom.gif)

```dart
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BadHeroPreviewer(
          displayWidget: Container(
            color: Colors.green,
            child: const Text('Click Me!'),
          ),
          previewWidget: Container(
            color: Colors.orange,
            alignment: Alignment.center,
            child: const Text(
              'Wow!\nYou clicked me!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

#### BadRefreshable

[source code](./lib/wrapper/refreshable.dart)

A simple encapsulation of [easy_refresh](https://pub.dev/packages/easy_refresh), providing pull-down refresh and pull-up
loading.

![](./media/refreshable.gif)

```dart
class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _count = 10;

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      _count = 10;
    });
  }

  Future<void> fetch() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      _count += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Text('Total: $_count'),
      body: BadRefreshable(
        onRefresh: refresh,
        onLoadMore: fetch,
        child: ListView.separated(
          itemCount: _count,
          itemBuilder: (_, int index) {
            return ListTile(title: Text('Item $index'));
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
      ),
    );
  }
}
```

## Useful Tips

- When using input components, do not use `borderRadius` and non-fully enclosed `border` at the same time. (will result
  in unexpected lines at the rounded corners)