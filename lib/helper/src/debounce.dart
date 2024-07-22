import 'dart:async';

/// a debouncer that calls the function after a specified delay
class BadDebouncer {
  final Duration delay;

  /// default action to be called when the debouncer is called without a action
  final void Function()? defaultAction;

  Timer? _timer;

  BadDebouncer({this.delay = const Duration(seconds: 1), this.defaultAction});

  void call([void Function()? action]) {
    assert(
      action != null || defaultAction != null,
      'can only call debouncer without action when defaultAction is provided',
    );

    _timer?.cancel();
    _timer = Timer(delay, (action ?? defaultAction)!);
  }

  /// cancel the current delayed call
  void cancel() => _timer?.cancel();
}
