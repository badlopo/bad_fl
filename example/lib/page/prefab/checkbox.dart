import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class PrefabCheckboxView extends StatefulWidget {
  const PrefabCheckboxView({super.key});

  @override
  State<StatefulWidget> createState() => _PrefabCheckboxViewState();
}

class _PrefabCheckboxViewState extends State<PrefabCheckboxView> {
  bool _v1 = false;
  bool _v2 = false;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Checkbox Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1: Regular Checkbox
          BadCheckbox.icon(
            size: 24,
            icon: const Icon(Icons.check, size: 18),
            checked: _v1,
            border: Border.all(),
            onTap: () {
              setState(() => _v1 = !_v1);
            },
          ),
          // Example 2: Custom Icon Builder
          BadCheckbox.iconBuilder(
            size: 24,
            iconBuilder: (c) {
              return c
                  ? const Icon(Icons.check, color: Colors.green)
                  : const Icon(Icons.close, color: Colors.red);
            },
            checked: _v2,
            onTap: () {
              setState(() => _v2 = !_v2);
            },
          ),
          // Example 3: Multiple States (3 states)
          BadCheckbox.iconBuilder(
            size: 24,
            iconBuilder: (c) {
              return c
                  ? const Icon(Icons.check, color: Colors.green)
                  : _count % 3 == 1
                      ? const Icon(Icons.close, color: Colors.red)
                      : const Icon(Icons.remove, color: Colors.blue);
            },
            checked: _count % 3 == 0,
            onTap: () {
              setState(() => _count += 1);
            },
          ),
        ],
      ),
    );
  }
}
