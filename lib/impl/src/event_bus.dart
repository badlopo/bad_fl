typedef EventListener = void Function(Object? payload);

/// EventBus implementation
abstract class EventBusImpl {
  static final Map<String, Set<EventListener>> _registry = {};

  /// Add an [EventListener] on event with given type.
  static addEventListener(String type, EventListener listener) {
    final listeners = _registry[type];
    if (listeners == null) {
      _registry[type] = {listener};
    } else {
      listeners.add(listener);
    }
  }

  /// Remove the listener on event with given type. If `listener` is not
  /// specified, all listeners on event with given type will be removed.
  static removeEventListener(String type, [EventListener? listener]) {
    if (listener != null) {
      _registry[type]?.remove(listener);
    } else {
      _registry.remove(type);
    }
  }

  /// Dispatch event on given type with payload.
  ///
  /// Since we use [LinkedHashSet] to store listeners internally,
  /// so all listeners will be called in the order they are added.
  static dispatchEvent(String type, [Object? payload]) {
    final listeners = _registry[type];
    if (listeners != null) {
      for (final listener in listeners) {
        listener(payload);
      }
    }
  }
}
