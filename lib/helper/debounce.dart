import 'dart:async';

/// a task that will be debounced
typedef DebounceTask = FutureOr<void> Function();

class DebounceImpl {
  /// inner task
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

  /// refresh the debounce timer
  void call() {
    _timer?.cancel();
    _timer = Timer(_duration, _task);
  }
}
