import 'package:bad_fl/widgets.dart';
import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final String code;

  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ColoredBox(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BadText.selectable(
            code,
            color: Colors.black87,
            fontSize: 14,
            lineHeight: 21,
          ),
        ),
      ),
    );
  }
}
