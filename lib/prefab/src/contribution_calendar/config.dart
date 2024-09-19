part of 'contribution_calendar.dart';

typedef ColorGetter = Color Function(int value, int min, int max);

/// github style colors in 5 shades
const _colors = [
  Color(0xFFEBEDF0),
  Color(0xFF9BE9A8),
  Color(0xFF40C463),
  Color(0xFF30A14E),
  Color(0xFF216E39),

  /// add an extra repeated value cause
  /// both left and right are closed intervals
  Color(0xFF216E39),
];

/// Default color getter for single cell
Color _defaultCellColorGetter(int value, int min, int max) {
  if (value < min || value > max) {
    throw RangeError('value must be between min and max');
  }

  return _colors[(value - min) * 5 ~/ (max - min)];
}

/// configuration for [ContributionCalendar]
class ContributionCalendarConfig {
  /// size of single cell
  final double cellSize;

  /// gap between cells (same for both horizontal and vertical)
  final double cellGap;

  /// border radius of single cell
  final double borderRadius;

  /// height of the calendar
  final double height;

  /// get color of a cell based on its value
  final Color Function(int value, int min, int max) getCellColor;

  const ContributionCalendarConfig({
    this.cellSize = 10,
    this.cellGap = 3,
    this.borderRadius = 2,
    ColorGetter cellColorGetter = _defaultCellColorGetter,
  })  : assert(cellSize > 0 && cellGap > 0),
        height = cellSize * 7 + cellGap * 6,
        getCellColor = cellColorGetter;
}
