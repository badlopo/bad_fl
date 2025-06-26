extension IterableExt<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] whose elements are a [Record] containing the element and its index.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final animals = ["cat", "dot", "rabbit"];
  /// for (final animal in animals.enumerate) {
  ///   print(animal);
  /// }
  ///
  /// // Output:
  /// // (0, cat)
  /// // (1, dot)
  /// // (2, rabbit)
  /// ```
  Iterable<(int index, E entry)> get enumerate {
    int index = -1;
    return map((item) {
      index += 1;
      return (index, item);
    });
  }

  /// Apply [convert] to each item and insert the [separator] between
  /// each `<groupSize>` items (not including the beginning and the end).
  ///
  /// Returns a new [Iterable] (not lazy) with the converted items and separators.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final nums = [1, 2, 3];
  /// final result = nums.separate(convert: (n) => n * 2, separator: -1);
  /// print(result);
  ///
  /// // Output:
  /// // (2, -1, 4, -1, 6)
  /// ```
  Iterable<To> separate<To>({
    required To Function(E) convert,
    required To separator,
    int groupSize = 1,
  }) sync* {
    assert(groupSize > 0);

    int counter = 0;
    for (final E entry in this) {
      if (counter == groupSize) {
        counter = 0;
        yield separator;
      }

      counter += 1;
      yield convert(entry);
    }
  }

  /// Shortcut for `separate(..).toList()`.
  List<To> separateToList<To>({
    required To Function(E) convert,
    required To separator,
    int groupSize = 1,
  }) =>
      separate(
        convert: convert,
        separator: separator,
        groupSize: groupSize,
      ).toList();
}
