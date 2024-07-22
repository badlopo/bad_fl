typedef EventHandler = void Function(dynamic eventData);

typedef StopListen = void Function();

/// event center implementation
abstract class EvCenterImpl {
  static final Map<String, Set<EventHandler>> _handlers = {};

  /// register [handler] on [eventName]
  static StopListen listen(String eventName, EventHandler handler) {
    var handlers = _handlers[eventName];
    if (handlers == null) {
      _handlers[eventName] = {handler};
    } else {
      handlers.add(handler);
    }

    return () {
      handlers?.remove(handler);
    };
  }

  /// remove specific [handler] on [eventName],
  /// if [handler] is null, remove all handlers in [eventName]
  static void unListen(String eventName, [EventHandler? handler]) {
    if (handler == null) {
      _handlers.remove(eventName);
    } else {
      _handlers[eventName]?.remove(handler);
    }
  }

  /// remove all handlers in all events
  static void unListenAll() {
    _handlers.clear();
  }

  /// trigger the [eventName] with [eventData]
  static void trigger(String evName, [dynamic eventData]) {
    var handlers = _handlers[evName];
    if (handlers == null) {
      return;
    }

    for (var handler in handlers) {
      handler(eventData);
    }
  }
}
