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
          const Text('BadTextInput with background color'),
          BadTextInput(
            height: 36,
            borderRadius: 4,
            fill: Colors.grey[200],
          ),
          const Divider(),
          const Text('BadTextInput with border'),
          BadTextInput(
            height: 36,
            border: Border.all(),
            borderRadius: 4,
          ),
          const Divider(),
          const Text('BadTextInput with underline'),
          BadTextInput(
            height: 36,
            border: const Border(bottom: BorderSide()),
          ),
          const Divider(),
          const Text('BadTextInput with prefix / suffix / ...'),
          BadTextInput(
            height: 36,
            placeholder: 'Search something ...',
            placeholderStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              fontWeight: FontWeight.w400,
            ),
            border: const Border(bottom: BorderSide()),
            prefixWidget: const Icon(Icons.search),
            suffixWidget: TextButton(
              onPressed: () {
                print('confirm');
              },
              child: const Text('Confirm'),
            ),
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
