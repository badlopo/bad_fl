import 'package:bad_fl/helper/debounce.dart';
import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/helper/debounce.dart';

const _description =
    '''Wrap a function in [DebounceImpl] to make it a debounced function.

That is: the call to the function will be delayed until [Duration] has elapsed since the last time it was invoked.''';

const _basic = '''/// create a debounced function with a 1 second delay
final debouncedLog = DebounceImpl(() => print('triggered'), const Duration(seconds: 1));

void main() {
  // trigger the debounced function multiple times in a short period
  debouncedLog();
  debouncedLog();
  debouncedLog();

  // only one 'triggered' will be printed after 1 second
  // output: triggered
}''';

const _changeDuration = '''void main() async {
  var watcher = Stopwatch();

  /// create a debounced function with a 1 second delay
  final debouncedLog = DebounceImpl(
    () {
      watcher.stop();
      print('elapsed: \${watcher.elapsed}');
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
}''';

class _DebounceController extends GetxController {
  final count = 0.obs;
  final sec = 1.obs;
  late final DebounceImpl increase;

  void changeDuration(String str) {
    int? to = int.tryParse(str);
    if (to != null) {
      increase.duration = Duration(seconds: to);
      sec.value = to;
    }
  }

  _DebounceController() {
    increase = DebounceImpl(
      () => count.value += 1,
      const Duration(seconds: 1),
    );
  }
}

class DebouncePage extends GetView<_DebounceController> {
  const DebouncePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(_DebounceController());

    return DocPageScaffold(
      title: 'class: DebounceImpl',
      sourceUrl: _sourceUrl,
      category: 'helper',
      playground: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: CupertinoTextField(
              prefix: const BadText('set duration:').paddingOnly(left: 4),
              suffix: const BadText('s').paddingOnly(right: 4),
              controller: TextEditingController(text: '1'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: controller.changeDuration,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Obx(
                () => BadText(
                  'count: ${controller.count}',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => BadText(
                  '(applied duration: ${controller.sec}s)',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              fixedSize: const Size.fromHeight(32),
            ),
            onPressed: () => controller.count.value = 0,
            child: const BadText('reset count (to 0)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              fixedSize: const Size.fromHeight(32),
            ),
            onPressed: () => controller.count.value += 1,
            child: const BadText('increase (directly)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              fixedSize: const Size.fromHeight(32),
            ),
            onPressed: controller.increase.call,
            child: const BadText('increase (debounced)'),
          ),
        ],
      ),
      description: _description,
      examples: const [
        ('Basic Usage', _basic),
        ('Change Duration', _changeDuration),
      ],
    );
  }
}
