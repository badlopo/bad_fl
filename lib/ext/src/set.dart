extension SetExt<T> on Set<T> {
  /// Adds `value` to the set if not exists,
  /// removes `value` from the set otherwise.
  bool toggle(T value) {
    if (contains(value)) {
      remove(value);
      return false;
    } else {
      add(value);
      return true;
    }
  }
}
