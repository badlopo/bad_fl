import 'dart:async';

/// a task that will be debounced
typedef DebounceTask = FutureOr<void> Function();

class DebounceImpl {
  /// default task (fallback if not overridden)
  final DebounceTask _task;

  /// duration to debounce
  Duration _duration;

  /// debounce timer
  Timer? _timer;

  DebounceImpl(this._task, this._duration);

  /// set duration to debounce, this will take effect on the next call
  set duration(Duration duration) {
    _duration = duration;
  }

  /// refresh the debounce timer (and override the task if needed)
  void call([DebounceTask? overrideTask]) {
    _timer?.cancel();
    _timer = Timer(_duration, overrideTask ?? _task);
  }
}

void main() async {
  final debounce =
      DebounceImpl(() => print('debounced'), const Duration(seconds: 1));
  debounce();
  await Future.delayed(const Duration(milliseconds: 500));
  debounce();
  debounce(() => print('overridden'));
  debounce();
}
