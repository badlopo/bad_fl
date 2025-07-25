import 'package:bad_fl/widgets.dart';
import 'package:flutter/material.dart';

const _lorem =
    '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: BadText(
              'Container',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          BadPreview(
            previewWidgetBuilder: (_, child) => UnconstrainedBox(child: child),
            child: Container(width: 200, height: 200, color: Colors.red),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: BadText(
              'Text',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const BadPreview(
            previewWidget: Center(child: BadText(_lorem, color: Colors.white)),
            child: BadText(_lorem),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: BadText(
              'Image',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          BadPreview(
            child: Image.network(
              'https://picsum.photos/200',
              width: 200,
              height: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: BadText(
              'Custom previewWidget & background color',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          BadPreview(
            color: Colors.grey,
            previewWidget:
                Container(width: 200, height: 200, color: Colors.orange),
            previewWidgetBuilder: (_, child) => UnconstrainedBox(child: child),
            child: Container(width: 200, height: 200, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
