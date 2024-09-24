part of 'contribution_calendar.dart';

/// factory function to create a single cell of the calendar
Widget _createCalendarCell({
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

class ContributionCalendar extends StatefulWidget {
  final ContributionCalendarController? controller;
  final ContributionCalendarConfig config;
  final DateTimeRange dateTimeRange;
  final Map<DateTime, int> dateTimeValues;

  const ContributionCalendar({
    super.key,
    this.controller,
    this.config = const ContributionCalendarConfig(),
    required this.dateTimeRange,
    required this.dateTimeValues,
  });

  @override
  State<ContributionCalendar> createState() => _ContributionCalendarState();
}

class _ContributionCalendarState extends State<ContributionCalendar> {
  /// border radius of single cell
  late BorderRadius? borderRadius;

  /// date time range of the calendar
  late DateTimeRange dateTimeRange;

  DateTime get firstDay => dateTimeRange.start;

  /// values of the calendar rendered now
  late Map<DateTime, int?> dateTimeValues;

  /// value range of the calendar
  late (int?, int?) valueRange;

  /// number of blank cells at the start of the calendar (before the first day)
  late int blankCells;

  /// number of cells to render in total (including blank cells)
  late int totalCells;

  /// layout the calendar
  void _layout() {
    // calculate the value range
    int? min, max;
    for (final value in dateTimeValues.values) {
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
    valueRange = (min, max);

    // calculate the number of blank cells and total cells
    final int firstDay = dateTimeRange.start.weekday;
    final int base = widget.config.firstDayOfWeek;
    blankCells = (firstDay - base + 7) % 7;
    totalCells = blankCells + dateTimeRange.duration.inDays + 1;
  }

  /// update the date time range of the calendar and re-layout
  ///
  /// Note: this will clamp the date time range to the start of the first day internally
  void _updateDateTimeRange(DateTimeRange range) {
    setState(() {
      dateTimeRange = DateUtils.datesOnly(range);
      _layout();
    });
  }

  /// update values of the calendar and re-layout
  void _updateValues(Map<DateTime, int?> others) {
    setState(() {
      dateTimeValues
        ..addAll(others)
        ..removeWhere((key, value) => value == null);
      _layout();
    });
  }

  @override
  void initState() {
    super.initState();

    // hold a reference to the controller
    if (widget.controller != null) widget.controller!._state = this;

    // initialize the state of the calendar
    borderRadius = widget.config.borderRadius == 0
        ? null
        : BorderRadius.circular(widget.config.borderRadius);
    dateTimeRange = DateUtils.datesOnly(widget.dateTimeRange);
    dateTimeValues = widget.dateTimeValues;

    // layout the calendar
    _layout();
  }

  @override
  void didUpdateWidget(covariant ContributionCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    borderRadius = widget.config.borderRadius == 0
        ? null
        : BorderRadius.circular(widget.config.borderRadius);
    dateTimeRange = DateUtils.datesOnly(widget.dateTimeRange);
    dateTimeValues = widget.dateTimeValues;

    _layout();
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
      child: Row(
        children: [
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: widget.config.cellGap,
                crossAxisSpacing: widget.config.cellGap,
                childAspectRatio: 1,
              ),
              itemCount: totalCells,
              itemBuilder: (_, index) {
                // TODO
                if (index % 8 == 7) {
                  return Container(
                    color: Colors.red,
                  );
                }

                // render blank cells before the first day
                if (index < blankCells) return const SizedBox.shrink();

                final date = firstDay.add(Duration(days: index - blankCells));
                final cellValue = dateTimeValues[date];

                return _createCalendarCell(
                  size: widget.config.cellSize,
                  color: widget.config.getCellColor(cellValue, valueRange),
                  borderRadius: borderRadius,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
