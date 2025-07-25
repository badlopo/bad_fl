import 'package:bad_fl/utils/helper.dart' as helper;

extension IterableExt<E> on Iterable<E> {
  /// {@macro bad_fl_doc_separate}
  Iterable<To> separate<To>({
    required To Function(E) convert,
    required To separator,
    int groupSize = 1,
  }) =>
      helper.separate(
        this,
        convert: convert,
        separator: separator,
        groupSize: groupSize,
      );

  /// All it does is chain `toList()` after `separate`.
  List<To> separateToList<To>({
    required To Function(E) convert,
    required To separator,
    int groupSize = 1,
  }) =>
      separate(convert: convert, separator: separator, groupSize: groupSize)
          .toList();

  /// {@macro bad_fl_doc_zip}
  Iterable<(E, E2)> zip<E2>(Iterable<E2> other) => helper.zip(this, other);
}
