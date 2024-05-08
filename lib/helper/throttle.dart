import 'dart:async';

class BadThrottler {
  /// default action to be called when the throttler is called without a action
  final FutureOr<void> Function()? defaultAction;

  bool _running = false;

  BadThrottler({this.defaultAction});

  Future<void> call(FutureOr<void> Function() action) async {
    if (_running) return;

    _running = true;
    await action();
    _running = false;
  }
}
