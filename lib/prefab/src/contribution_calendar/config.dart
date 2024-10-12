part of 'contribution_calendar.dart';

typedef CellColorGetter = Color Function(int? value, int? min, int? max);

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

Color _defaultColorGetter(int? value, int? _, int? max) {
  // if value is null or 0, return the color for empty cell
  if (value == null || value == 0) return _colors[0];

  return _colors[value * 4 ~/ max! + 1];
}

const List<String> _defaultWeekAxisLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun'
];

const List<String> _defaultMonthAxisLabels = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

class CalendarConfig {
  final int firstDayOfWeek;
  final List<String> weekAxisLabels;
  final Color weekAxisColor;

  final List<String> monthAxisLabels;
  final Color monthAxisColor;

  final double cellSize;
  final double cellGap;
  final Radius cellRadius;
  final CellColorGetter cellColorGetter;

  const CalendarConfig({
    this.firstDayOfWeek = DateTime.monday,
    this.weekAxisLabels = _defaultWeekAxisLabels,
    this.weekAxisColor = const Color(0xFF333333),
    this.monthAxisLabels = _defaultMonthAxisLabels,
    this.monthAxisColor = const Color(0xFF333333),
    this.cellSize = 12,
    this.cellGap = 3,
    this.cellRadius = const Radius.circular(2),
    this.cellColorGetter = _defaultColorGetter,
  });
}

/// configuration for the layout of the calendar
///
/// Note: this is for internal use only
class CalendarLayoutConfig {
  /// the [CalendarConfig] passed to the [ContributionCalendar] widget
  final CalendarConfig rawConfig;

  /// first date in the calendar
  final DateTime dateBase;

  /// number of weeks (columns) in the calendar
  final int weeks;

  /// values of the calendar
  final Map<DateTime, int?> values;

  /// offset of the paint when drawing next cell
  final double paintOffset;

  /// size of the canvas
  final Size size;

  /// number of blank cells at the start of the calendar (before the first day)
  final int blankCells;

  /// number of date cells in the calendar
  final int dateCells;

  /// minimum value in the calendar, if any
  final int? minValue;

  /// maximum value in the calendar, if any
  final int? maxValue;

  /// calculate the layout configuration for the calendar from other configurations
  factory CalendarLayoutConfig.calculate({
    required CalendarConfig config,
    required DateTimeRange range,
    required Map<DateTime, int?> values,
  }) {
    // calculate the number of blank cells and total cells
    final int firstDay = range.start.weekday;
    final int base = config.firstDayOfWeek;
    final int blanks = (firstDay - base + 7) % 7;
    final int dates = range.duration.inDays + 1;

    // calculate the value range
    int? min, max;
    for (final value in values.values) {
      if (value == null) continue;

      if (min == null) {
        // first value encountered
        min = value;
        max = value;
      } else {
        // update min and max
        if (value < min) {
          min = value;
        } else if (value > max!) {
          max = value;
        }
      }
    }

    // calculate the number of weeks (columns)
    final weeks = ((blanks + dates) / 7).ceil();

    return CalendarLayoutConfig._(
      rawConfig: config,
      weeks: weeks,
      dateBase: range.start,
      values: values,
      paintOffset: config.cellSize + config.cellGap,
      size: Size(
        config.cellSize * weeks + config.cellGap * (weeks - 1),
        config.cellSize * 8 + config.cellGap * 7,
      ),
      blankCells: blanks,
      dateCells: dates,
      minValue: min,
      maxValue: max,
    );
  }

  const CalendarLayoutConfig._({
    required this.rawConfig,
    required this.dateBase,
    required this.weeks,
    required this.values,
    required this.paintOffset,
    required this.size,
    required this.blankCells,
    required this.dateCells,
    required this.minValue,
    required this.maxValue,
  });

  /// get the date (and it's value) at the given position, return null if the position is not on a cell
  (DateTime date, int? value)? getDateAt(Offset position) {
    // check if the point is on a cell
    if (position.dx < 0 ||
        position.dy < 0 ||
        position.dx % paintOffset > rawConfig.cellSize ||
        position.dy % paintOffset > rawConfig.cellSize) return null;

    final x = (position.dx / paintOffset).ceil();
    final y = (position.dy / paintOffset).ceil();

    // check if the position is outside the calendar
    if (x > weeks || y > 7) return null;

    final dateOffset = (x - 1) * 7 + y - blankCells - 1;

    // check if the date is outside the range (in the blank cells)
    if (dateOffset < 0 || dateOffset >= dateCells) return null;

    final date = dateBase.add(Duration(days: dateOffset));
    return (date, values[date]);
  }
}
