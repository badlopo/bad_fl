import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl/layout/tree.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BadTree<Map<String, dynamic>>(
          root: const {
            'name': 'root',
            'children': [
              {
                'name': 'child1',
                'children': [
                  {'name': 'child1.1'},
                  {'name': 'child1.2'},
                ],
              },
              {
                'name': 'child2',
                'children': [
                  {'name': 'child2.1'},
                  {'name': 'child2.2'},
                ],
              }
            ],
          },
          childrenProvider: (node) {
            final c = node['children'];
            if (c == null) return null;
            return List<Map<String, dynamic>>.from(c);
          },
          nodeBuilder: (node, depth) {
            return Padding(
              padding: EdgeInsets.only(left: 16.0 * depth),
              child: Container(
                width: double.infinity,
                child: BadText('$depth:${node['name']}'),
              ),
            );
          },
          onNodeTap: (controller) => controller.toggleExpanded(),
        ),
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
