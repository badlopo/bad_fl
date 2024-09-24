part of 'contribution_calendar.dart';

enum WeekAxisPosition { left, right }

enum MonthAxisPosition { top, bottom }

/// internal usage
extension _ModValue on MonthAxisPosition {
  int get modValue {
    switch (this) {
      case MonthAxisPosition.top:
        return 0;
      case MonthAxisPosition.bottom:
        return 7;
    }
  }
}

class ContributionCalendar extends StatefulWidget {
  final ContributionCalendarController? controller;
  final ContributionCalendarConfig config;
  final DateTimeRange dateTimeRange;
  final Map<DateTime, int> dateTimeValues;

  /// widget to render as the week axis,
  /// this will be fixed at the start(or end) of the calendar
  final Widget? weekAxis;

  /// position of the week axis, takes effect only if [weekAxis] is not null
  final WeekAxisPosition weekAxisPosition;

  final MonthAxisPosition monthAxisPosition;

  const ContributionCalendar({
    super.key,
    this.controller,
    this.config = const ContributionCalendarConfig(),
    required this.dateTimeRange,
    required this.dateTimeValues,
    this.weekAxis,
    this.weekAxisPosition = WeekAxisPosition.left,
    this.monthAxisPosition = MonthAxisPosition.bottom,
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

    return SizedBox(
      height: widget.config.widgetHeight,
      child: Row(
        crossAxisAlignment: widget.monthAxisPosition == MonthAxisPosition.top
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // conditionally render: week axis
          if (widget.weekAxis != null &&
              widget.weekAxisPosition == WeekAxisPosition.left)
            SizedBox(
              height: widget.config.calendarHeight,
              child: widget.weekAxis!,
            ),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: widget.config.cellGap,
                crossAxisSpacing: widget.config.cellGap,
                childAspectRatio: 1,
              ),
              // here we don't provide the itemCount,
              // instead we return null in itemBuilder to indicate the end of the list
              itemBuilder: (_, index) {
                // render month axis if needed
                if (index % 8 == widget.monthAxisPosition.modValue) {
                  // TODO: render month name at the center of the month
                  // if (index == 15) {
                  //   return UnconstrainedBox(
                  //     // we only overflow in the horizontal direction,
                  //     // so we keep the vertical direction constrained
                  //     constrainedAxis: Axis.vertical,
                  //     child: SizedOverflowBox(
                  //       size: Size(
                  //         widget.config.cellSize + 6,
                  //         widget.config.cellSize,
                  //       ),
                  //       child: Container(
                  //         width: widget.config.cellSize + 6,
                  //         height: widget.config.cellSize,
                  //         // color: Colors.orange,
                  //         child: Text('Jan'),
                  //       ),
                  //     ),
                  //   );
                  // }

                  return Container(
                    color: Colors.orange,
                  );
                }

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
          if (widget.weekAxis != null &&
              widget.weekAxisPosition == WeekAxisPosition.right)
            SizedBox(
              height: widget.config.calendarHeight,
              child: widget.weekAxis!,
            ),
        ],
      ),
    );
  }
}
