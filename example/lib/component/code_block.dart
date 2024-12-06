import 'package:bad_fl/bad_fl.dart';
import 'package:example/style.dart';
import 'package:flutter/material.dart';

class CodeBlock extends StatelessWidget {
  final EdgeInsets? margin;
  final String? name;
  final String code;

  void handleCopy() {
    ClipboardImpl.writeText(code);

    // TODO: toast
  }

  const CodeBlock({
    super.key,
    this.margin,
    this.name,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (name != null) Text(name!, style: Styles.code),
              const Spacer(),
              BadClickable(
                onClick: handleCopy,
                child: const Icon(Icons.copy, size: 14, color: Colors.black87),
              ),
            ],
          ),
          const Divider(height: 16, color: Colors.white),
          Text(code, style: Styles.code),
        ],
      ),
    );
  }
}
