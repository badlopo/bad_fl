import 'dart:async';

import 'package:bad_fl/prefab/otp_input.dart';
import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/wrapper/clickable.dart';
import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:bad_fl_doc/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/prefab/otp_input.dart';

const _description = '''Widget for otp code input.''';

const _eg1 = '''BadOTPInput(
  width: 280,
  height: 32,
  space: 10,
  placeholder: 'Enter your otp code',
  style: const TextStyle(color: Colors.grey, fontSize: 14),
  border: const Border(bottom: BorderSide()),
  prefixWidget: const BadText('OTP:'),
  onSendTapped: () => print('send tapped'),
  onChanged: (value) => print('value changed to "\$value"'),
  onSubmitted: (value) => print('submitted with "\$value"'),
)''';

const _eg2 = '''BadOTPInput(
  width: 360,
  height: 32,
  space: 10,
  placeholder: 'Enter your otp code',
  style: const TextStyle(color: Colors.grey, fontSize: 14),
  border: const Border(bottom: BorderSide()),
  prefixWidget: const BadText('OTP:'),
  sendWidget: isOtpAvailable > 0
    ? BadText(
        'Available in \$countdown seconds',
        color: Colors.grey,
        fontSize: 12,
      )
    : const BadText('Get OTP', color: Colors.blue, fontSize: 12),
  ),
  onSendTapped: () {
    // send otp code here
  },
  onChanged: (value) => print('value changed to "\$value"'),
  onSubmitted: (value) => print('submitted with "\$value"'),
)''';

class _OTPInputController extends GetxController {
  final RxString action = 'no action'.obs;

  Timer? timer;
  final RxInt countdown = 0.obs;

  void sendOTP() {
    if (countdown.value > 0) {
      action('Resend is not allowed yet, wait for $countdown seconds.');
      return;
    }

    action('OTP sent');
    countdown.value = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => BadText('Last action: ${controller.action}')),
          const SizedBox(height: 12),
          BadOTPInput(
            width: 360,
            height: 32,
            space: 10,
            placeholder: 'Enter your otp code',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            border: const Border(bottom: BorderSide()),
            prefixWidget: const BadText('OTP:'),
            sendWidget: Obx(
              () => controller.countdown.value > 0
                  ? BadText(
                      'Available in ${controller.countdown.value} seconds',
                      color: Colors.grey,
                      fontSize: 12,
                    )
                  : const BadText('Get OTP', color: Colors.blue, fontSize: 12),
            ),
            onSendTapped: controller.sendOTP,
            onChanged: (value) =>
                controller.action('value changed to "$value"'),
            onSubmitted: (value) =>
                controller.action('submitted with "$value"'),
          ),
          const SizedBox(height: 12),
          const BadText(
            'This is a demonstration of "BadOTPInput"\'s unique features. Refer to "BadTextInput" to see more about the properties and methods of the "Input family".',
            color: Colors.orange,
            fontSize: 14,
          ),
          Clickable(
            onClick: () => Get.toNamed(NamedRoute.text_input),
            child: const BadText(
              '=> Link to "BadTextInput"',
              color: Colors.blue,
              fontSize: 14,
              italic: true,
            ),
          )
        ],
      ),
      description: _description,
      examples: const [
        ('Basic usage', _eg1),
        ('With sending frequency limit', _eg2),
      ],
    );
  }
}
