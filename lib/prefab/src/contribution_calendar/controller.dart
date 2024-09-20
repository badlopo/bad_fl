part of 'contribution_calendar.dart';

class ContributionCalendarController {
  /// state of the calendar widget
  _ContributionCalendarState? _state;

  /// update the date time range of the calendar
  void updateDateTimeRange({DateTime? from, DateTime? to}) {
    assert(_state != null, 'controller is not attached to any calendar');

    _state!._updateDateTimeRange(from: from, to: to);
  }

  /// update the value of a single date
  void updateValue(DateTime date, int value) {
    assert(_state != null, 'controller is not attached to any calendar');

    _state!._updateValues({date: value});
  }

  /// update the values of multiple dates
  void updateValues(Map<DateTime, int> values) {
    assert(_state != null, 'controller is not attached to any calendar');

    _state!._updateValues(values);
  }

  /// get the value of a single date
  int getValue(DateTime date) {
    assert(_state != null, 'controller is not attached to any calendar');

    return _state!.values[date] ?? 0;
  }

  /// get the values of multiple dates
  Map<DateTime, int> getValues(Set<DateTime> dates) {
    assert(_state != null, 'controller is not attached to any calendar');

    return {for (final date in dates) date: _state!.values[date] ?? 0};
  }
}
