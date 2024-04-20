import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/helper/throttle.dart';

const _description =
    '''Wrap a function in [ThrottleImpl] to make it a throttled function.

That is: once the function is called, the following calls will be ignored until the first call is completed.''';

const _basic = '''void main() async {
  var count = 1;

  final throttledLog = ThrottleImpl(() async {
    print('count is \$count');

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
}''';

class _ThrottleController extends GetxController {}

class ThrottlePage extends GetView<_ThrottleController> {
  const ThrottlePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(_ThrottleController());

    return DocPageScaffold(
      title: 'class: ThrottleImpl',
      sourceUrl: _sourceUrl,
      category: 'helper',
      playground: Column(
        children: [
          // TODO
        ],
      ),
      description: _description,
      examples: [('Basic Usage', _basic)],
    );
  }
}
