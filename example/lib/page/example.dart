import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// this page is used to test example code in the documentation
// class Example extends StatelessWidget {
//   final RxInt activeIndex = 0.obs;
//
//   Example({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Obx(
//             () => BadRadio(
//               activeIndex: activeIndex.value,
//               onTap: (int to) {
//                 activeIndex.value = to;
//                 print('tapped $to');
//               },
//               height: 32,
//               borderRadius: 16,
//               fill: Colors.grey[200],
//               activeFill: Colors.blue[200],
//               values: const ['Item1', 'Item2', 'Item3'],
//               childBuilder: (label) => BadText(label),
//               activeChildBuilder: (label) => BadText(
//                 '$label!',
//                 color: Colors.white,
//               ),
//             ),
//           ).paddingAll(16),
//         ],
//       ),
//     );
//   }
// }

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BadRadio(
            activeIndex: activeIndex,
            onTap: (int to) {
              setState(() {
                activeIndex = to;
              });
              print('tapped $to');
            },
            height: 32,
            borderRadius: 16,
            fill: Colors.grey[200],
            activeFill: Colors.blue[200],
            values: const ['Item1', 'Item2', 'Item3'],
            childBuilder: (label) => BadText(label),
            activeChildBuilder: (label) {
              return BadText('$label!', color: Colors.white);
            },
          ),
        ],
      ),
    );
  }
}
