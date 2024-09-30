part of 'contribution_calendar.dart';

class _CalendarPainter extends CustomPainter {
  final CalendarLayoutConfig layoutConfig;

  double get paintOffset => layoutConfig.paintOffset;

  double get cellSize => layoutConfig.rawConfig.cellSize;

  double get cellGap => layoutConfig.rawConfig.cellGap;

  Radius get cellRadius => layoutConfig.rawConfig.cellRadius;

  CellColorGetter get cellColorGetter => layoutConfig.rawConfig.cellColorGetter;

  const _CalendarPainter(this.layoutConfig);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    int ptr = -layoutConfig.blankCells;

    draw:
    for (int c = 0;; c += 1) {
      for (int r = 0; r < 7; r += 1) {
        ptr += 1;

        // blank cell
        if (ptr <= 0) continue;
        // finish drawing
        if (ptr > layoutConfig.dateCells) break draw;

        final date = layoutConfig.dateBase.add(Duration(days: ptr - 1));
        paint.color = cellColorGetter(
          layoutConfig.values[date],
          layoutConfig.minValue,
          layoutConfig.maxValue,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(paintOffset * c, paintOffset * r, cellSize, cellSize),
            cellRadius,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CalendarPainter oldDelegate) => false;
}

class ContributionCalendar extends StatefulWidget {
  final CalendarController? controller;
  final CalendarConfig config;
  final DateTimeRange range;
  final Map<DateTime, int> values;

  const ContributionCalendar({
    super.key,
    this.controller,
    this.config = const CalendarConfig(),
    required this.range,
    required this.values,
  });

  @override
  State<ContributionCalendar> createState() => _ContributionCalendarState();
}

class _ContributionCalendarState extends State<ContributionCalendar> {
  late DateTimeRange range;
  late Map<DateTime, int?> values;

  late CalendarLayoutConfig _layoutConfig;

  void _layout() {
    _layoutConfig = CalendarLayoutConfig.calculate(
      config: widget.config,
      range: range,
      values: values,
    );
  }

  /// update the date time range of the calendar and re-layout
  ///
  /// Note: this will clamp the date time range to the start of the first day internally
  void updateRange(DateTimeRange range) {
    setState(() {
      this.range = DateUtils.datesOnly(range);

      _layout();
    });
  }

  /// update values of the calendar and re-layout, set null to remove the value
  void updateValues(Map<DateTime, int?> others) {
    setState(() {
      values
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

    range = DateUtils.datesOnly(widget.range);
    values = widget.values;

    _layout();
  }

  /// this is more for hot reload
  @override
  void didUpdateWidget(covariant ContributionCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    range = DateUtils.datesOnly(widget.range);
    values = widget.values;

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
    assert(widget.config.weekAxisLabels.length == 7,
        'weekAxisLabels must have exactly 7 items');

    final weekAxis = Column(
      children: <Widget>[
        for (final label in widget.config.weekAxisLabels)
          Text(
            label,
            style: TextStyle(
              color: widget.config.weekAxisColor,
              fontSize: widget.config.cellSize,
              height: 1,
            ),
          ),
      ].slotted(slot: SizedBox(height: widget.config.cellGap)),
    );

    return SizedBox(
      // width: double.infinity,
      height: _layoutConfig.size.height,
      child: Row(
        children: [
          weekAxis,
          SizedBox(width: widget.config.cellGap),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onTapDown: (ev) {
                  // TODO: implement tap down event
                  print('tap down: ${ev.localPosition}');
                },
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: _layoutConfig.size,
                    painter: _CalendarPainter(_layoutConfig),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
