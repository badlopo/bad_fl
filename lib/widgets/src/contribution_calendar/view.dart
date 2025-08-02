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

    // 日期单元格计数游标, 正数表示日期计数, 负数为前置空白单元格
    int cellPtr = -layoutConfig.blankCells;
    // 月份游标 (当前列游标对应的月份, 正向统计/反向绘制 时使用)
    int monthPtr = layoutConfig.dateBase.month;

    // index of columns where a new month starts
    final List<int> monthAxisLabelIndex = [0];

    // 绘制日期单元格 & 统计月份信息
    draw_date_cell:
    for (int c = 0;; c += 1) {
      for (int r = 0; r < 7; r += 1) {
        cellPtr += 1;

        // blank cell
        if (cellPtr <= 0) continue;
        // finish drawing cells
        if (cellPtr > layoutConfig.dateCells) break draw_date_cell;

        // 绘制日期单元格
        final date = layoutConfig.dateBase.add(Duration(days: cellPtr - 1));
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

        // 统计月份信息
        if (date.month != monthPtr) {
          monthAxisLabelIndex.add(c);
          monthPtr = date.month;
        }
      }
    }

    // 绘制月份坐标轴
    final painter = TextPainter()..textDirection = TextDirection.ltr;
    final double monthAxisYBase = paintOffset * 7;

    // 月份坐标轴标签
    final axisLabels = layoutConfig.rawConfig.monthAxisLabels;
    // 上一次绘制了月份标签的列的下标
    int colIndexPtr = layoutConfig.weeks;
    for (int colIndex in monthAxisLabelIndex.reversed) {
      // colIndex 是离散的值, 为了避免最右侧绘制时没有足够的空间,
      // 此处限制至少有两列的空间才进行绘制
      if (colIndexPtr - colIndex > 2) {
        // draw month axis labels
        painter
          ..text = TextSpan(
            text: axisLabels[monthPtr - 1],
            style: TextStyle(
              color: Colors.black,
              fontSize: cellSize,
              height: 1,
            ),
          )
          ..layout()
          ..paint(canvas, Offset(paintOffset * colIndex, monthAxisYBase));
      }

      // move the ptr
      colIndexPtr = colIndex;
      monthPtr = (monthPtr == 1) ? 12 : (monthPtr - 1);
    }
    // print(monthAxisLabelIndex);
  }

  @override
  bool shouldRepaint(covariant _CalendarPainter oldDelegate) => false;
}

class BadContributionCalendar extends StatefulWidget {
  final CalendarController? controller;
  final CalendarConfig config;
  final DateTimeRange range;
  final Map<DateTime, int> values;
  final void Function(DateTime date, int? value)? onDateTap;

  const BadContributionCalendar({
    super.key,
    this.controller,
    this.config = const CalendarConfig(),
    required this.range,
    required this.values,
    this.onDateTap,
  });

  @override
  State<BadContributionCalendar> createState() => _ContributionCalendarState();
}

class _ContributionCalendarState extends State<BadContributionCalendar> {
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
  void didUpdateWidget(covariant BadContributionCalendar oldWidget) {
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
      ].separateToList(
        separator: SizedBox(height: widget.config.cellGap),
        convert: asIs,
      ),
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
                  final cell = _layoutConfig.getDateAt(ev.localPosition);
                  if (cell != null && widget.onDateTap != null) {
                    widget.onDateTap!(cell.$1, cell.$2);
                  }
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
