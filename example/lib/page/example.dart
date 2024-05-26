import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl/layout/tree.dart';
import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final ff = Finalizer((msg) => print(msg));
              dynamic a = {1, 2, 3};
              ff.attach(a, 'a has been finalized');
              a = null;

              await Future.delayed(Duration(seconds: 1));
              print('xx');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BadTree<Map<String, dynamic>>(
          tree: const {
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
          childrenProvider: (node) => node['children'],
          nodeBuilder: (node) {
            return Padding(
              padding: EdgeInsets.only(left: 16.0 * node.depth),
              child: BadClickable(
                onClick: node.toggleExpanded,
                child: Container(
                  width: double.infinity,
                  child: BadText(
                      '${node.depth}: ${node.expanded ? '√' : '×'} ${node.data['name']}'),
                ),
              ),
            );
          },
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
