import 'package:bad_fl/helper/throttle.dart';

void main() async {
  var count = 1;

  final throttledLog = ThrottleImpl(() async {
    print('count is $count');

    // delay a future for 1 second to simulate a long running task
    await Future.delayed(const Duration(seconds: 1));
    print('done');
  });

  // trigger the function -- first call
  throttledLog();  // count is 1
  count += 1;

  // trigger the function several times -- the following calls will be ignored
  throttledLog();
  count += 1;

  throttledLog();
  count += 1;

  throttledLog();
  count += 1;

  // wait until the first call is completed
  await Future.delayed(const Duration(seconds: 1));
  throttledLog();  // count is 5
}
