import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

const _lorem =
    '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.''';

class TextPage extends StatelessWidget {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          BadText(_lorem),
          Divider(),
          BadText(
            _lorem,
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          Divider(),
          BadText(_lorem, underline: true, italic: true),
          Divider(),
          BadText(_lorem, maxLines: 1),
          Divider(),
          BadText(_lorem, lineHeight: 24, letterSpacing: 2),
        ],
      ),
    );
  }
}
