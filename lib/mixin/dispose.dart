import 'package:bad_fl/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// auto execute dispose for [ScrollController]
mixin BadDisposeScrollMixin on GetxController {
  final sc = ScrollController();

  @override
  void onClose() {
    sc.dispose();
    BadFl.log(
      module: 'BadDisposeScrollMixin',
      message: 'auto execute dispose for "ScrollController"',
    );
    super.onClose();
  }
}

/// auto execute dispose for [TextEditingController]
mixin BadDisposeTextEditingMixin on GetxController {
  final tec = TextEditingController();

  @override
  void onClose() {
    tec.dispose();
    BadFl.log(
      module: 'BadDisposeScrollMixin',
      message: 'auto execute dispose for "TextEditingController"',
    );
    super.onClose();
  }
}
