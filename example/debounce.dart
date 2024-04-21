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

  watcher.start();
  debouncedLog(); // this call will be executed after about 1 second

  // wait until the first call is executed
  await Future.delayed(const Duration(seconds: 2));

  // change the duration to 2 seconds
  debouncedLog.duration = const Duration(seconds: 2);

  watcher
    ..reset()
    ..start();
  debouncedLog(); // this call will be executed after about 2 seconds
}
