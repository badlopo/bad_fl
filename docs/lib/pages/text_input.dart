import 'dart:ui';

import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:bad_fl/prefab/text_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/prefab/text_input.dart';

const _description = '''Widget for plain text input.''';

const _eg1 = '''BadTextInput(
  width: 320,
  height: 28,
  initialValue: '',
  placeholder: 'your name here',
  prefixWidget: const BadText('Enter your name:'),
  style: const TextStyle(fontSize: 14, color: Colors.grey),
  border: const Border(bottom: BorderSide(color: Colors.grey)),
  onChanged: (s) => print('value changed to \$s'),
  onSubmitted: (s) => print('submit with value \$s'),
)''';

const _eg2 = '''BadTextInput(
  height: 32,
  initialValue: '',
  placeholder: 'numbers only',
  inputType: TextInputType.number,
  prefixWidget: const BadText('Password (numbers only):'),
  style: const TextStyle(fontSize: 14, color: Colors.grey),
  border: Border.all(color: Colors.grey),
  borderRadius: 4,
  formatters: [FilteringTextInputFormatter.digitsOnly],
  onChanged: (s) => print('value changed to \$s'),
  onSubmitted: (s) => print('submit with value \$s'),
)''';

const _style = TextStyle(fontSize: 14, color: Colors.grey);

class _TextInputController extends GetxController {
  final RxString action = 'no action'.obs;

  final RxDouble width = 200.0.obs;
  final RxDouble height = 32.0.obs;
  final RxDouble space = 10.0.obs;
  final RxString placeholder = 'ABC123+-='.obs;
  final RxDouble fontSize = 14.0.obs;
  final RxDouble borderRadius = 8.0.obs;

  void setWidth(String s) =>
      width(clampDouble(double.tryParse(s) ?? 200.0, 50, 360));

  void setHeight(String s) =>
      height(clampDouble(double.tryParse(s) ?? 32.0, 24, 48));

  void setSpace(String s) =>
      space(clampDouble(double.tryParse(s) ?? 10.0, 0, 24));

  void setPlaceholder(String s) => placeholder(s);

  void setFontSize(String s) =>
      fontSize(clampDouble(double.tryParse(s) ?? 14.0, 10, 24));

  void setBorderRadius(String s) =>
      borderRadius(clampDouble(double.tryParse(s) ?? 8.0, 0, 24));
}

class TextInputPage extends GetView<_TextInputController> {
  const TextInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(_TextInputController());

    return DocPageScaffold(
      title: 'widget: BadTextInput',
      sourceUrl: _sourceUrl,
      category: 'prefab',
      playground: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => BadText('Last action: ${controller.action}')),
          const SizedBox(height: 12),
          Obx(
            () => BadTextInput(
              width: controller.width.value,
              height: controller.height.value,
              space: controller.space.value,
              placeholder: controller.placeholder.value,
              style: TextStyle(
                color: Colors.grey,
                fontSize: controller.fontSize.value,
              ),
              border: Border.all(),
              borderRadius: controller.borderRadius.value,
              onChanged: (value) =>
                  controller.action('value changed to "$value"'),
              onSubmitted: (value) =>
                  controller.action('submitted with "$value"'),
            ),
          ),
          const SizedBox(height: 12),
          const BadText(
            'Change the input field properties below to see the effect:',
            color: Colors.brown,
            fontSize: 18,
          ),
          const SizedBox(height: 12),
          BadTextInput(
            height: 28,
            initialValue: '200',
            inputType: TextInputType.number,
            prefixWidget: const BadText('Width (50-360): '),
            style: _style,
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: controller.setWidth,
          ),
          const SizedBox(height: 12),
          BadTextInput(
            height: 28,
            initialValue: '32',
            inputType: TextInputType.number,
            prefixWidget: const BadText('Height (24-48): '),
            style: _style,
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: controller.setHeight,
          ),
          const SizedBox(height: 12),
          BadTextInput(
            height: 28,
            initialValue: '10',
            inputType: TextInputType.number,
            prefixWidget: const BadText('Space (0-24): '),
            style: _style,
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: controller.setSpace,
          ),
          const SizedBox(height: 12),
          BadTextInput(
            height: 28,
            initialValue: 'ABC123+-=',
            inputType: TextInputType.number,
            prefixWidget: const BadText('Placeholder: '),
            style: _style,
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            onChanged: controller.setPlaceholder,
          ),
          const SizedBox(height: 12),
          BadTextInput(
            height: 28,
            initialValue: '14',
            inputType: TextInputType.number,
            prefixWidget: const BadText('FontSize (10-24): '),
            style: _style,
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: controller.setFontSize,
          ),
          const SizedBox(height: 12),
          BadTextInput(
            height: 28,
            initialValue: '8',
            inputType: TextInputType.number,
            prefixWidget: const BadText('Border Radius (0-24): '),
            style: _style,
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            formatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: controller.setBorderRadius,
          ),
          const SizedBox(height: 12),
        ],
      ),
      description: _description,
      examples: const [
        ('Underlined', _eg1),
        ('Number Only', _eg2),
      ],
    );
  }
}
