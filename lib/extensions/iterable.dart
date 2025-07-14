import 'package:bad_fl/utils/helper.dart';

extension IterableExt<E> on Iterable<E> {
  /// see [separate].
  Iterable<To> toSeperated<To>({
    required To Function(E) convert,
    required To separator,
    int groupSize = 1,
  }) sync* {
    yield* separate(this,
        convert: convert, separator: separator, groupSize: groupSize);
  }

  /// Shortcut for `toSeperated(..).toList()`.
  List<To> toSeperatedList<To>({
    required To Function(E) convert,
    required To separator,
    int groupSize = 1,
  }) =>
      toSeperated(convert: convert, separator: separator, groupSize: groupSize)
          .toList();
}
