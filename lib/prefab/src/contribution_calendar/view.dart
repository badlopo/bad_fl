part of 'contribution_calendar.dart';

/// factory function to create a single cell of the calendar
Widget _createCalendarCell({
  required double size,
  required Color color,
  required BorderRadius? borderRadius,
}) {
  /// TODO: margin between cells
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, borderRadius: borderRadius),
  );
}

class ContributionCalendar extends StatefulWidget {
  final ContributionCalendarController? controller;
  final ContributionCalendarConfig config;
  final DateTimeRange dateTimeRange;
  final Map<DateTime, int> values;

  const ContributionCalendar({
    super.key,
    this.controller,
    this.config = const ContributionCalendarConfig(),
    required this.dateTimeRange,
    required this.values,
  });

  @override
  State<ContributionCalendar> createState() => _ContributionCalendarState();
}

class _ContributionCalendarState extends State<ContributionCalendar> {
  /// border radius of single cell
  late final BorderRadius? borderRadius;

  /// date time range of the calendar
  ///
  /// Note: this can be changed by the controller
  late DateTimeRange dateTimeRange;

  /// values of the calendar rendered now
  late Map<DateTime, int> values;

  /// value range of the calendar
  ///
  /// Note: this can be changed by the controller
  late (int, int) valueRange;

  void _updateDateTimeRange({DateTime? from, DateTime? to}) {
    setState(() {
      dateTimeRange = DateTimeRange(
        start: from ?? dateTimeRange.start,
        end: to ?? dateTimeRange.end,
      );
    });
  }

  void _updateValues(Map<DateTime, int> values) {
    // TODO: update the value of a single date
  }

  @override
  void initState() {
    super.initState();

    // hold a reference to the controller
    if (widget.controller != null) widget.controller!._state = this;

    borderRadius = widget.config.borderRadius == 0
        ? null
        : BorderRadius.circular(widget.config.borderRadius);
    dateTimeRange = widget.dateTimeRange;
    values = widget.values;
    // TODO: calculate value range
  }

  @override
  void dispose() {
    // release the reference held by the controller
    if (widget.controller != null) widget.controller!._state = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.config.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // TODO: render the calendar with real values
            Column(
              children: [
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
                _createCalendarCell(
                    size: widget.config.cellSize,
                    color: Colors.red,
                    borderRadius: borderRadius),
              ],
            )
          ],
        ),
      ),
    );
  }
}
