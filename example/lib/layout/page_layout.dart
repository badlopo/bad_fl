import 'package:example/component/html_text.dart';
import 'package:flutter/material.dart';

class WidgetPageLayout extends StatelessWidget {
  final String title;
  final Iterable<Widget> children;

  const WidgetPageLayout({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          HtmlText.h1(title),
          ...children,
        ],
      ),
    );
  }
}
