import 'package:bad_fl/prefab/text.dart';
import 'package:flutter/material.dart';

class CheckBoxView extends StatelessWidget {
  const CheckBoxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('BadCheckBox')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BadText('WIP',),
        ],
      ),
    );
  }
}
