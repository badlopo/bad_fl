import 'package:bad_fl/prefab/text.dart';
import 'package:flutter/material.dart';

class ButtonView extends StatelessWidget {
  const ButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('BadButton')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BadText('WIP',)
        ],
      ),
    );
  }
}
