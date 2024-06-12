extension NumExt on num {
  String readableFixed([int fractionDigits = 1]) {
    final absVal = abs();

    switch (absVal) {
      case < 1e3:
        return toStringAsFixed(fractionDigits);
      case < 1e6:
        return '${(this / 1e3).toStringAsFixed(fractionDigits)}K';
      case < 1e9:
        return '${(this / 1e6).toStringAsFixed(fractionDigits)}M';
      default:
        return '${(this / 1e9).toStringAsFixed(fractionDigits)}B';
    }
  }

  String get readable => readableFixed();
}
