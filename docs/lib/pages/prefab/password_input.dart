import 'package:bad_fl_doc/_shared/doc_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _sourceUrl =
    'https://github.com/badlopo/bad_fl/blob/master/lib/prefab/password_input.dart';

const _description = '''Widget for password text input.''';

class _PasswordInputController extends GetxController {}

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
