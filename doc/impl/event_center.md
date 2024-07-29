# impl/event_center

- [Source code](../../lib/impl/src/event_center.dart)
- [GitHub Gist](https://gist.github.com/lopo12123/46e2a8552af50a0bcab3911e991c2367)
- [Live Example](https://dartpad.dev/?id=46e2a8552af50a0bcab3911e991c2367&run=true&channel=stable)

## Methods

```dart
typedef EventHandler = void Function(dynamic eventData);

typedef StopListen = void Function();
```

### listen

`StopListen listen(String eventName, EventHandler handler)`

add a `handler` on `eventName`

### unListen

`void unListen(String eventName, [EventHandler? handler])`

remove specific `handler` on `eventName`, if `handler` is `null`, remove all handlers on `eventName`

### unListenAll

`void unListenAll()`

remove all handlers on all events

### trigger

`void trigger(String evName, [dynamic eventData])`

trigger all handlers on `evName` with `eventData`