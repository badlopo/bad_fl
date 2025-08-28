/// Filter out null values in a list.
Iterable<T> nonNull<T extends Object>(Iterable<T?> source) =>
    source.whereType<T>();

/// {@template bad_fl_doc_separate}
/// Apply [convert] to each item and insert the [separator] between
/// each `<groupSize>` items (not including the beginning and the end).
///
/// Returns a new [Iterable] with the converted items and separators.
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
/// {@endtemplate}
void _docSeparate() {}

/// {@macro bad_fl_doc_separate}
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

/// {@template bad_fl_doc_zip}
/// 'Zips up' two iterators into a single iterator of pairs.
///
/// It returns a new iterator that will iterate over two other iterators,
/// returning a tuple where the first element comes from the first iterator,
/// and the second element comes from the second iterator.
/// In other words, it zips two iterators together, into a single one.
///
/// ## Examples
///
/// ``` dart
/// final s1 = [1, 2, 3];
/// final s2 = ['a', 'b', 'c', 'd'];
///
/// print(zip(s1, s2));
///
/// // Output:
/// // ((1, a), (2, b), (3, c))
///
/// print(zip(s2, s1));
///
/// // Output:
/// // ((a, 1), (b, 2), (c, 3))
/// ```
/// {@endtemplate}
void _docZip() {}

/// {@macro bad_fl_doc_zip}
Iterable<(A, B)> zip<A, B>(Iterable<A> a, Iterable<B> b) sync* {
  // iterators
  final ita = a.iterator;
  final itb = b.iterator;

  // non-null flag
  bool nna = ita.moveNext();
  bool nnb = itb.moveNext();

  // yields tuples where both a and b exists
  while (nna && nnb) {
    yield (ita.current, itb.current);

    nna = ita.moveNext();
    nnb = itb.moveNext();
  }
}
