import 'package:bad_fl/helper/debounce.dart';

void main() async {
  var watcher = Stopwatch();

  /// create a debounced function with a 1 second delay
  final debouncedLog = DebounceImpl(
    () {
      watcher.stop();
      print('elapsed: ${watcher.elapsed}');
    },
    const Duration(seconds: 1),
  );

  // == usage 1: basic ==
  watcher.start();
  debouncedLog(); // this call will be executed after about 1 second
  await Future.delayed(const Duration(seconds: 2)); // wait until executed

  // == usage 2: set duration ==
  // change the duration to 2 seconds
  debouncedLog.duration = const Duration(seconds: 2);
  watcher
    ..reset()
    ..start();
  debouncedLog(); // this call will be executed after about 2 seconds
  await Future.delayed(const Duration(seconds: 3));

  // == usage 3: override task ==
  watcher
    ..reset()
    ..start();
  debouncedLog(() {
    print('overridden task with elapsed: ${watcher.elapsed}');
  }); // this call will be executed with the overridden task
  await Future.delayed(const Duration(seconds: 2));
  debouncedLog(); // this call will be executed with the default task
}
