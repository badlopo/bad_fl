import 'package:example/_shared/sample_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _description =
    '''Wrap a function in [DebounceImpl] to make it a debounced function.

That is: the call to the function will be delayed until [Duration] has elapsed since the last time it was invoked.''';

class _DebounceController extends GetxController {
  final count = 0.obs;
}

class DebouncePage extends GetView<_DebounceController> {
  const DebouncePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SamplePage(
      title: 'DebounceImpl',
      description: _description,
    );
  }
}
