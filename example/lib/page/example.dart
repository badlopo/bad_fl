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
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BadSwitch(
            width: 64,
            height: 32,
            gap: 2,
            active: active,
            handleColorActive: Colors.orange,
            trackColor: Colors.grey[200]!,
            trackColorActive: Colors.orange[200]!,
            onTap: () {
              setState(() {
                active = !active;
              });
              print('active: $active');
            },
          ),
        ],
      ),
    );
  }
}
