import 'dart:async';

abstract interface class RetryableController<T> {
  void terminate();

  void finish(T result);
}

class Retryable<T> implements RetryableController<T> {
  final Completer<T> _completer = Completer();

  final Duration duration;

  /// Times to retry, null means unlimited retries.
  int? _retry;

  bool _running = false;

  final FutureOr<void> Function(RetryableController<T> controller) task;

  /// [immediate] Whether to execute the task immediately after creation.
  Retryable({
    this.duration = Duration.zero,
    int? retry,
    required this.task,
    bool immediate = true,
  }) : _retry = retry {
    if (immediate) {
      Future.microtask(() {
        execute();
      });
    }
  }

  void execute() async {
    if (_running) return;
    _running = true;

    while (!_completer.isCompleted && _retry != 0) {
      await task(this);
      if (_retry != null) _retry = _retry! - 1;
      await Future.delayed(duration);
    }
  }

  @override
  void finish(T result) {
    if (_completer.isCompleted) return;
    _completer.complete(result);
  }

  @override
  void terminate() {
    if (_completer.isCompleted) return;
    _completer.completeError(StateError('Task terminated'));
  }

  Future<T> get result async => _completer.future;
}
