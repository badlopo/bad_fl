extension NumExt on num {
  /// Convert to a human-readable string (e.g. `1234` -> `1.2K`).
  ///
  /// - [fractionDigits]: the (max) number of digits after the decimal point.
  /// - [forceFraction]: force to display fraction digits even if it's zero. if `false`, trailing zeros will be removed.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 10203.toReadable(1);  // "10.2K"
  /// 10203.toReadable(2);  // "10.2K"
  /// 10203.toReadable(2, true);  // "10.20K"
  /// 10203.toReadable(3);  // "10.203K"
  /// ```
  String toReadable([int fractionDigits = 1, bool forceFraction = false]) {
    final absVal = abs();

    String raw = '';
    String unit = '';

    switch (absVal) {
      case < 1e3:
        raw = toStringAsFixed(fractionDigits);
        break;
      case < 1e6:
        raw = (this / 1e3).toStringAsFixed(fractionDigits);
        unit = 'K';
        break;
      case < 1e9:
        raw = (this / 1e6).toStringAsFixed(fractionDigits);
        unit = 'M';
        break;
      default:
        raw = (this / 1e9).toStringAsFixed(fractionDigits);
        unit = 'B';
        break;
    }

    // remove trailing zeros (after the dot) if not forceFraction
    if (!forceFraction) raw = raw.replaceAll(RegExp(r'\.0+$'), '');

    return '$raw$unit';
  }

  /// alias of `toReadable()`
  String get readable => toReadable();

  /// Convert to a grouped string (e.g. `1234567` -> `1,234,567`).
  ///
  /// - [separator]: the separator between each group. should be a single character.
  ///
  /// ## Example
  ///
  /// ```dart
  /// 12345678.toGrouped();  // "12,345,678"
  /// 12345678.toGrouped('-');  // "12-345-678"
  /// 12345678.toGrouped('\'');  // "12'345'678"
  /// ```
  String toGrouped([String separator = ',']) {
    assert(separator.length == 1, 'separator must be a single character');

    final str = toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match match) => '${match[1]}$separator');
  }

  /// Alias of `toGrouped()`
  String get grouped => toGrouped();
}
