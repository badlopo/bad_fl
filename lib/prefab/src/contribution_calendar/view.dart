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

// TODO: Mapping: (r, c) => date
// TODO: calendar column factory
// TODO: date range (from, to)

class ContributionCalendar extends StatefulWidget {
  final ContributionCalendarController? controller;
  final ContributionCalendarConfig config;

  const ContributionCalendar({
    super.key,
    this.controller,
    required this.config,
  });

  @override
  State<ContributionCalendar> createState() => _ContributionCalendarState();
}

class _ContributionCalendarState extends State<ContributionCalendar> {
  late final BorderRadius? borderRadius;

  @override
  void initState() {
    super.initState();

    borderRadius = widget.config.borderRadius == 0
        ? null
        : BorderRadius.circular(widget.config.borderRadius);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
