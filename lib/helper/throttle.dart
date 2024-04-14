import 'dart:async';

/// a task that will be throttled
typedef ThrottleTask = FutureOr<void> Function();

class ThrottleImpl {
  /// inner task
  final ThrottleTask _task;

  /// running flag
  bool _running = false;

  ThrottleImpl(this._task);

  /// trigger the task
  Future<void> call() async {
    if (_running) return;

    _running = true;
    await _task();
    _running = false;
  }
}
