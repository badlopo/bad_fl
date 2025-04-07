import 'package:flutter/widgets.dart';

extension ScrollControllerExt on ScrollController {
  void clampInExtent() {
    if (!hasClients) return;

    if (offset > position.maxScrollExtent) jumpTo(position.maxScrollExtent);
  }
}
