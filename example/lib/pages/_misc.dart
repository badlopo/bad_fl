import 'package:bad_fl/prefab/text.dart';
import 'package:flutter/material.dart';

class MiscPage extends StatelessWidget {
  const MiscPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Misc')),
      body: Column(
        children: [
          Hero(
            tag: 'test',
            child: Container(
              width: 100,
              height: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
