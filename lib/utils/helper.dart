/// Returns the input value as is.
T asIs<T>(T it) => it;

/// Filter out null values in a list.
Iterable<T> nonNull<T extends Object>(Iterable<T?> source) =>
    source.whereType<T>();

/// Apply [convert] to each item and insert the [separator] between
/// each `<groupSize>` items (not including the beginning and the end).
///
/// Returns a new [Iterable] (not lazy) with the converted items and separators.
///
/// ## Example
///
/// ```dart
/// final nums = [1, 2, 3];
/// final result = separate(nums, convert: (v) => v * 2, separator: -1);
/// print(result);
///
/// // Output:
/// // (2, -1, 4, -1, 6)
/// ```
Iterable<To> separate<From, To>(
  Iterable<From> source, {
  required To Function(From from) convert,
  required To separator,
  int groupSize = 1,
}) sync* {
  assert(groupSize > 0);

  int count = 0;
  for (final From from in source) {
    if (count == groupSize) {
      count = 0;
      yield separator;
    }

    count += 1;
    yield convert(from);
  }
}
