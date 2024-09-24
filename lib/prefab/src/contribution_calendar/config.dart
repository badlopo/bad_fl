part of 'contribution_calendar.dart';

/// github style colors in 5 shades
const _colors = [
  /// color for empty cell
  Color(0xFFEBEDF0),

  /// colors for cells with values
  Color(0xFF9BE9A8),
  Color(0xFF40C463),
  Color(0xFF30A14E),
  Color(0xFF216E39),

  /// add an extra repeated value cause
  /// both left and right are closed intervals
  Color(0xFF216E39),
];

typedef ColorGetter = Color Function(int? value, (int? min, int? max) range);

/// Default color getter for single cell
Color _defaultColorGetter(int? value, (int? min, int? max) range) {
  // if value is null or 0, return the color for empty cell
  if (value == null || value == 0) return _colors[0];

  // if value is not null, min and max cannot be null
  assert(range.$1 != null && range.$2 != null, 'unreachable state');

  // value must be in the range of min and max
  assert(range.$1! <= value && value <= range.$2!,
      'value must be in the range of min and max');

  return _colors[value * 4 ~/ range.$2! + 1];
}

typedef CellBuilder = Widget Function({
  required int? value,
  required double size,
  required Color color,
  required BorderRadius? borderRadius,
});

/// factory function to create a single cell of the calendar
Widget _defaultCellBuilder({
  required int? value,
  required double size,
  required Color color,
  required BorderRadius? borderRadius,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, borderRadius: borderRadius),
  );
}

/// configuration for [ContributionCalendar]
class ContributionCalendarConfig {
  /// first day of the week (first row)
  final int firstDayOfWeek;

  /// size of single cell
  final double cellSize;

  /// gap between cells (same for both horizontal and vertical)
  final double cellGap;

  /// border radius of single cell
  final double borderRadius;

  /// height of the calendar
  final double calendarHeight;

  /// height of the widget (including the month axis)
  final double widgetHeight;

  /// get color of a cell based on its value
  final ColorGetter colorGetter;

  /// build a single cell of the calendar
  final CellBuilder cellBuilder;

  const ContributionCalendarConfig({
    this.firstDayOfWeek = DateTime.sunday,
    this.cellSize = 10,
    this.cellGap = 3,
    this.borderRadius = 2,
    this.colorGetter = _defaultColorGetter,
    this.cellBuilder = _defaultCellBuilder,
  })  : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'firstDayOfWeek must be between monday(1) and sunday(7)',
        ),
        assert(cellSize > 0, 'cellSize must be greater than 0'),
        assert(cellGap > 0, 'cellGap must be greater than 0'),
        assert(borderRadius >= 0,
            'borderRadius must be greater than or equal to 0'),
        calendarHeight = cellSize * 7 + cellGap * 6,
        widgetHeight = cellSize * 8 + cellGap * 7;
}
