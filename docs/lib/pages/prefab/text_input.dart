import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:bad_fl/prefab/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/prefab/text_input.dart';

const _description = '''Widget for plain text input.''';

class _TextInputController extends GetxController {}

class TextInputPage extends GetView<_TextInputController> {
  const TextInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPageScaffold(
      title: 'widget: BadTextInput',
      sourceUrl: _sourceUrl,
      category: 'prefab',
      playground: Column(
        children: [
          BadTextInput(
            width: 200,
            height: 32,
            space: 10,
            placeholder: '测试',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            border: Border.all(),
            borderRadius: 8,
            // prefixWidget: Container(
            //   width: 36,
            //   height: 36,
            //   color: Colors.blue,
            // ),
            onChanged: (value) {
              print('changed: $value');
            },
            onSubmitted: (value) {
              print('submitted: $value');
            },
          ),
        ],
      ),
      description: _description,
    );
  }
}
