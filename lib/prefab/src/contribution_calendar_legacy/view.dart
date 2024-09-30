part of 'contribution_calendar.dart';

/// TODO: WIP!
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

  /// number of date cells in the calendar
  late int dateCells;

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
    dateCells = dateTimeRange.duration.inDays + 1;
  }

  /// setup the calendar (initialize values & do layout)
  void _setup() {
    borderRadius = widget.config.borderRadius == 0
        ? null
        : BorderRadius.circular(widget.config.borderRadius);
    dateTimeRange = DateUtils.datesOnly(widget.dateTimeRange);
    dateTimeValues = widget.dateTimeValues;

    _layout();
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

    _setup();
  }

  @override
  void didUpdateWidget(covariant ContributionCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _setup();
  }

  @override
  void dispose() {
    // release the reference held by the controller
    if (widget.controller != null) widget.controller!._state = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int padding = blankCells;
    int count = 0;

    final Widget weekAxis = SizedBox(
      height: widget.config.calendarHeight,
      child: widget.config.weekAxisBuilder(
        position: widget.config.weekAxisPosition,
        firstDayOfWeek: widget.config.firstDayOfWeek,
        cellSize: widget.config.cellSize,
        cellGap: widget.config.cellGap,
      ),
    );

    return SizedBox(
      height: widget.config.widgetHeight,
      child: Row(
        crossAxisAlignment:
            widget.config.monthAxisPosition == MonthAxisPosition.top
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          // conditionally render: week axis
          if (widget.config.weekAxisPosition == WeekAxisPosition.left)
            Padding(
              padding: EdgeInsets.only(right: widget.config.cellGap),
              child: weekAxis,
            ),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: widget.config.cellGap,
                crossAxisSpacing: widget.config.cellGap,
                childAspectRatio: 1,
              ),
              // here we don't provide the itemCount,
              // instead we return null in itemBuilder to indicate the end of the list
              itemCount: blankCells + dateCells,
              itemBuilder: (_, index) {
                // render blank cells before the first day
                if (padding > 0) {
                  padding -= 1;
                  return const SizedBox.shrink();
                }

                // if we have rendered all the date cells, return null to indicate the end
                if (count >= dateCells) return null;

                // render the calendar cell
                final val = dateTimeValues[firstDay.add(Duration(days: count))];
                final color = widget.config.colorGetter(val, valueRange);
                count += 1;

                return widget.config.cellBuilder(
                  value: val,
                  size: widget.config.cellSize,
                  color: color,
                  borderRadius: borderRadius,
                );
              },
            ),
          ),
          // conditionally render: week axis
          if (widget.config.weekAxisPosition == WeekAxisPosition.right)
            Padding(
              padding: EdgeInsets.only(left: widget.config.cellGap),
              child: weekAxis,
            ),
        ],
      ),
    );
  }
}
