import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/prefab/otp_input.dart';

const _description = '''Widget for otp code input.''';

class _OTPInputController extends GetxController {
  final RxString action = 'no action'.obs;
}

class OTPInputPage extends GetView<_OTPInputController> {
  const OTPInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(_OTPInputController());

    return DocPageScaffold(
      title: 'widget: BadOTPInput',
      sourceUrl: _sourceUrl,
      category: 'prefab',
      playground: Column(
        children: [
          // TODO
        ],
      ),
      description: _description,
      examples: [
        // TODO
      ],
    );
  }
}
