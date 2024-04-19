import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/layout/expandable.dart';
import 'package:example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:get/get.dart';

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return HighlightView(
      code,
      language: 'dart',
      theme: a11yLightTheme,
      textStyle: const TextStyle(
        fontSize: 14,
        height: 1.6,
        fontFamily: 'JetBrainsMono',
      ),
    );
  }
}

class DocPageScaffold extends StatelessWidget {
  /// title of the page
  final String title;

  /// tags of the item
  final List<String> tags;

  /// description of the item
  final String description;

  /// interactive playground
  final Widget? playground;

  /// list of code examples
  final List<(String, String)>? examples;

  const DocPageScaffold({
    super.key,
    required this.title,
    required this.tags,
    required this.description,
    required this.playground,
    this.examples,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BadText(title, fontWeight: FontWeight.w500),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        tooltip: 'Home',
        onPressed: () => Get.offAllNamed(NamedRoute.boot),
        child: const Icon(Icons.home_outlined, color: Colors.grey),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => Chip(label: BadText(tag))).toList(),
          ),
          // playground
          if (playground != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: BadExpandable(
                title: const BadText('Playground', fontWeight: FontWeight.w500),
                child: playground!,
              ),
            ),
          // description
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: BadExpandable(
              title: const BadText('Description', fontWeight: FontWeight.w500),
              child: BadText(description, fontSize: 14),
            ),
          ),
          // TODO: signature
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: BadExpandable(
              title: const BadText('Signature', fontWeight: FontWeight.w500),
              child: BadText(
                  'This is a sample page. This is a sample page. This is a sample page. This is a sample page.'),
            ),
          ),
          // examples
          ...?examples?.map(
            (example) => Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: BadExpandable(
                title: BadText(
                  'Example: ${example.$1}',
                  fontWeight: FontWeight.w500,
                ),
                // child: BadText(example.$2, fontSize: 14),
                child: _CodeBlock(code: example.$2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
