import 'dart:async';

/// a task that will be debounced
typedef DebounceTask = FutureOr<void> Function();

class DebounceImpl {
  /// inner task
  final DebounceTask _task;

  /// duration to debounce
  final Duration _duration;

  /// debounce timer
  Timer? _timer;

  DebounceImpl(this._task, this._duration);

  /// refresh the debounce timer
  call() {
    _timer?.cancel();
    _timer = Timer(_duration, _task);
  }
}
