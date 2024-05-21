import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('BadTextField with clear'),
          BadTextField(
            height: 108,
            borderRadius: 8,
            fill: Colors.grey[200]!,
            clearWidget: const Text('clear all!'),
          ),
          const Divider(),
          const Text('BadTextField with counter'),
          BadTextField(
            height: 108,
            borderRadius: 8,
            fill: Colors.grey[200]!,
            maxLength: 200,
          ),
        ],
      ),
    );
  }
}

// class Example extends StatefulWidget {
//   const Example({super.key});
//
//   @override
//   State<Example> createState() => _ExampleState();
// }
//
// class _ExampleState extends State<Example> {
//   bool active = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           BadText('BadText', color: Colors.grey),
//           BadText(lorem),
//           Divider(),
//           BadText('BadText with maxLine 1', color: Colors.grey),
//           BadText(lorem, maxLines: 1),
//           Divider(),
//           BadText('BadText.selectable', color: Colors.grey),
//           BadText.selectable(lorem),
//           Divider(),
//           BadText('BadText.selectable with maxLine 1', color: Colors.grey),
//           BadText.selectable(
//             lorem,
//             maxLines: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
