part of 'contribution_calendar.dart';

class CalendarController {
  /// state of the calendar widget
  _BadContributionCalendarState? _state;

  void updateRange({DateTime? from, DateTime? to}) {
    assert(from != null || to != null, 'from and to cannot be both null');
    assert(_state != null, 'controller is not attached to any calendar');

    // update the date time range of the calendar,
    // if not provided, keep the old value
    final range = DateTimeRange(
      start: from ?? _state!.range.start,
      end: to ?? _state!.range.end,
    );

    _state!.updateRange(range);
  }

  void updateValues(Map<DateTime, int?> others) {
    assert(_state != null, 'controller is not attached to any calendar');
    assert(others.isNotEmpty, 'others cannot be empty');

    _state!.updateValues(others);
  }

  /// Get the value of a single date, `null` if unset.
  int? getValue(DateTime date) {
    assert(_state != null, 'controller is not attached to any calendar');

    return _state!.values[date];
  }

  /// Get the values of multiple dates, `null` if unset.
  Map<DateTime, int?> getValues(Set<DateTime> dates) {
    assert(_state != null, 'controller is not attached to any calendar');

    return {for (final date in dates) date: _state!.values[date]};
  }
}
