import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// this page is used to test example code in the documentation
class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BadPasswordInput(
            width: 120,
            height: 32,
            border: Border.all(color: Colors.grey),
            borderRadius: 8,
            onVisibilityChanged: (to) {
              print('visibility: $to');
            },
            onSubmitted: (code) {
              print('submitted: $code');
            },
          ).paddingAll(16),
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
//   bool _v1 = false;
//   bool _v2 = false;
//   int _count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           BadCheckBox.icon(
//             size: 24,
//             icon: const Icon(Icons.check, size: 18),
//             checked: _v1,
//             border: Border.all(),
//             onTap: () {
//               setState(() {
//                 _v1 = !_v1;
//               });
//             },
//           ),
//           BadCheckBox.iconBuilder(
//             size: 24,
//             iconBuilder: (c) {
//               return c
//                   ? const Icon(
//                       Icons.check,
//                       color: Colors.green,
//                     )
//                   : const Icon(
//                       Icons.close,
//                       color: Colors.red,
//                     );
//             },
//             checked: _v2,
//             onTap: () {
//               setState(() {
//                 _v2 = !_v2;
//               });
//             },
//           ),
//           BadCheckBox.iconBuilder(
//             size: 24,
//             iconBuilder: (c) {
//               return c
//                   ? const Icon(
//                       Icons.check,
//                       color: Colors.green,
//                     )
//                   : _count % 3 == 1
//                       ? const Icon(
//                           Icons.close,
//                           color: Colors.red,
//                         )
//                       : const Icon(
//                           Icons.remove,
//                           color: Colors.blue,
//                         );
//             },
//             checked: _count % 3 == 0,
//             onTap: () {
//               setState(() {
//                 _count += 1;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
