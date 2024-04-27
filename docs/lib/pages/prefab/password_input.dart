import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/prefab/password_input.dart';
import 'package:bad_fl/wrapper/clickable.dart';
import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:bad_fl_doc/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/prefab/password_input.dart';

const _description = '''Widget for password text input.''';

const _eg1 = '''BadPasswordInput(
  width: 320,
  height: 32,
  space: 10,
  placeholder: 'Enter your password',
  visibleWidget: const BadText('now you see me'),
  hiddenWidget: const BadText('soon you won\\'t'),
  style: const TextStyle(color: Colors.grey, fontSize: 14),
  border: Border.all(),
  borderRadius: 8,
  onVisibilityChanged: (visible) => controller.action('visibility changed to "\$visible"'),
  onChanged: (value) => controller.action('value changed to "\$value"'),
  onSubmitted: (value) => controller.action('submitted with "\$value"'),
)''';

const _eg2 = '''BadPasswordInput(
  width: 200,
  height: 32,
  space: 10,
  placeholder: 'Enter your password',
  initialVisibility: true,
  style: const TextStyle(color: Colors.grey, fontSize: 14),
  border: const Border(bottom: BorderSide()),
  onVisibilityChanged: (visible) => controller.action('visibility changed to "\$visible"'),
  onChanged: (value) => controller.action('value changed to "\$value"'),
  onSubmitted: (value) => controller.action('submitted with "\$value"'),
)''';

class _PasswordInputController extends GetxController {
  final RxString action = 'no action'.obs;
}

class PasswordInputPage extends GetView<_PasswordInputController> {
  const PasswordInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(_PasswordInputController());

    return DocPageScaffold(
      title: 'widget: BadPasswordInput',
      sourceUrl: _sourceUrl,
      category: 'prefab',
      playground: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => BadText('Last action: ${controller.action}')),
          const SizedBox(height: 12),
          BadPasswordInput(
            width: 280,
            height: 32,
            space: 10,
            placeholder: 'Enter your password',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            border: Border.all(),
            borderRadius: 8,
            prefixWidget: const BadText('Password:', color: Colors.red),
            onVisibilityChanged: (visible) =>
                controller.action('visibility changed to "$visible"'),
            onChanged: (value) =>
                controller.action('value changed to "$value"'),
            onSubmitted: (value) =>
                controller.action('submitted with "$value"'),
          ),
          const SizedBox(height: 12),
          const BadText(
            'This is a demonstration of "BadPasswordInput"\'s unique features. Refer to "BadTextInput" to see more about the properties and methods of the "Input family".',
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
        ('Outlined with custom visible/hidden widget', _eg1),
        ('Underlined with initially visible', _eg2),
      ],
    );
  }
}
