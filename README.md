# About BadFL

BadFL includes encapsulation of commonly used utils and components, as well as secondary encapsulation of commonly used
libraries (such as `dio`, `hive`, `device_info_plus`, etc.)

It expresses component properties in a form closer to CSS representation, making it easier for web developers to get
started.

**NOTICE!!!** This library **completely** abandons semantics! (For example, `Container`+`GestureDetector` is used to
express a `Button` rather than build-in ones) People who have related needs or care about this should use it with
caution.

# Architecture

## Extension

Extension methods of built-in types, named in the form of `<Type>Ext`.

### [`ListExt`](./lib/extension/list.dart)

- `slotted`: build a new element from each element of the list and insert slot elements between every two elements.

## Helper

### [`DebounceImpl`](./lib/helper/debounce.dart)

Debounce implementation.

- set duration takes effect at the next call
- the overridden task only takes effect for the next call, if that call is canceled, the passed task is dropped.

```dart
void main() async {
  var watcher = Stopwatch();

  /// create a debounced function with a 1 second delay
  final debouncedLog = DebounceImpl(
        () {
      watcher.stop();
      print('elapsed: ${watcher.elapsed}');
    },
    const Duration(seconds: 1),
  );

  // == usage 1: basic ==
  watcher.start();
  debouncedLog(); // this call will be executed after about 1 second
  await Future.delayed(const Duration(seconds: 2)); // wait until executed

  // == usage 2: set duration ==
  // change the duration to 2 seconds
  debouncedLog.duration = const Duration(seconds: 2);
  watcher
    ..reset()
    ..start();
  debouncedLog(); // this call will be executed after about 2 seconds
  await Future.delayed(const Duration(seconds: 3));

  // == usage 3: override task ==
  watcher
    ..reset()
    ..start();
  debouncedLog(() {
    print('overridden task with elapsed: ${watcher.elapsed}');
  }); // this call will be executed with the overridden task
  await Future.delayed(const Duration(seconds: 2));
  debouncedLog(); // this call will be executed with the default task
}
```

### [`ThrottleImpl`](./lib/helper/throttle.dart)

Throttle implementation.

```dart
void main() async {
  var count = 1;

  final throttledLog = ThrottleImpl(() async {
    print('count is $count');

    // delay a future for 1 second to simulate a long running task
    await Future.delayed(const Duration(seconds: 1));
    print('done');
  });

  // trigger the function -- first call
  throttledLog(); // count is 1
  count += 1;

  // trigger the function several times -- the following calls will be ignored
  throttledLog();
  count += 1;

  throttledLog();
  count += 1;

  throttledLog();
  count += 1;

  // wait until the first call is completed
  await Future.delayed(const Duration(seconds: 1));
  throttledLog(); // count is 5
}
```

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

## Scaffold

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