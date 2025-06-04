import 'dart:js' as js show context;
import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class HtmlAnchor extends StatelessWidget {
  final String target;
  final Widget child;

  const HtmlAnchor({super.key, required this.target, required this.child});

  @override
  Widget build(BuildContext context) {
    return BadClickable(
      onClick: () {
        js.context.callMethod('open', [target]);
      },
      child: child,
    );
  }
}
