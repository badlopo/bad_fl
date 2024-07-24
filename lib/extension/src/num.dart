extension NumExt on num {
  String readableFixed([int fractionDigits = 1]) {
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

    final display = raw.replaceAll(RegExp(r'\.?0+$'), '');
    return '$display$unit';
  }

  String get readable => readableFixed();

  String get segmented {
    String str = toString();
    RegExp regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regExp, (Match match) => '${match[1]},');
  }
}
