part of 'contribution_calendar.dart';

class ContributionCalendarController {
  /// state of the calendar widget
  _ContributionCalendarState? _state;

  /// update the date time range of the calendar
  void updateDateTimeRange({DateTime? from, DateTime? to}) {
    assert(from != null || to != null, 'from and to cannot be both null');
    assert(_state != null, 'controller is not attached to any calendar');

    // update the date time range of the calendar,
    // if not provided, keep the old value
    final range = DateTimeRange(
      start: from ?? _state!.dateTimeRange.start,
      end: to ?? _state!.dateTimeRange.end,
    );

    // update the date time range of the calendar
    _state!._updateDateTimeRange(range);
  }

  /// update the value of a single date, set null to remove the value
  void updateValue(DateTime date, int? value) {
    assert(_state != null, 'controller is not attached to any calendar');

    _state!._updateValues({date: value});
  }

  /// update the values of multiple dates, set null to remove the value
  void updateValues(Map<DateTime, int?> values) {
    assert(_state != null, 'controller is not attached to any calendar');

    _state!._updateValues(values);
  }

  /// get the value of a single date, `null` if unset
  int? getValue(DateTime date) {
    assert(_state != null, 'controller is not attached to any calendar');

    return _state!.dateTimeValues[date];
  }

  /// get the values of multiple dates, `null` if unset
  Map<DateTime, int?> getValues(Set<DateTime> dates) {
    assert(_state != null, 'controller is not attached to any calendar');

    return {for (final date in dates) date: _state!.dateTimeValues[date]};
  }
}
