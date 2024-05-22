import 'dart:math';

import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _ExampleController extends GetxController with BadSearchMixin<String> {
  @override
  int get pageSize => 5;

  @override
  Future<Iterable<String>?> fetcher(String target, int pageNo) async {
    // wait for 1 second to simulate the network delay
    await Future.delayed(const Duration(seconds: 1));

    // mock the search result
    int base = (pageNo - 1) * pageSize;
    return List.generate(pageSize, (index) => 'Item ${base + index}');
  }

  @override
  void onReady() {
    super.onReady();

    nextPage();
  }
}

class Example extends GetView<_ExampleController> {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(_ExampleController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return controller.pending.isTrue
              ? const Text('status: pending')
              : const Text('status: idle');
        }),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.reloadPage,
                    child: const Text('Refresh'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.nextPage,
                    child: const Text('More'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: controller.sc,
                itemCount: controller.resultList.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(controller.resultList[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class Example extends StatelessWidget {
//   const Example({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Text('BadTextInput with background color'),
//           BadTextInput(
//             height: 36,
//             borderRadius: 4,
//             fill: Colors.grey[200],
//           ),
//           const Divider(),
//           const Text('BadTextInput with border'),
//           BadTextInput(
//             height: 36,
//             border: Border.all(),
//             borderRadius: 4,
//           ),
//           const Divider(),
//           const Text('BadTextInput with underline'),
//           BadTextInput(
//             height: 36,
//             border: const Border(bottom: BorderSide()),
//           ),
//           const Divider(),
//           const Text('BadTextInput with prefix / suffix / ...'),
//           BadTextInput(
//             height: 36,
//             placeholder: 'Search something ...',
//             placeholderStyle: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[400],
//               fontWeight: FontWeight.w400,
//             ),
//             border: const Border(bottom: BorderSide()),
//             prefixWidget: const Icon(Icons.search),
//             suffixWidget: TextButton(
//               onPressed: () {
//                 print('confirm');
//               },
//               child: const Text('Confirm'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
