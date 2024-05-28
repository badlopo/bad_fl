import 'package:bad_fl/layout/tree.dart';
import 'package:flutter/material.dart';

// class Example extends StatelessWidget {
//   const Example({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () async {
//               var a= {1,2,3};
//             },
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: BadTree<Map<String, dynamic>>(
//           tree: const {
//             'name': 'root',
//             'children': [
//               {
//                 'name': 'child1',
//                 'children': [
//                   {'name': 'child1.1'},
//                   {'name': 'child1.2'},
//                 ],
//               },
//               {
//                 'name': 'child2',
//                 'children': [
//                   {'name': 'child2.1'},
//                   {'name': 'child2.2'},
//                 ],
//               }
//             ],
//           },
//           childrenProvider: (node) => node['children'],
//           nodeBuilder: (node) {
//             return Padding(
//               padding: EdgeInsets.only(left: 16.0 * node.depth),
//               child: BadClickable(
//                 onClick: node.toggleExpanded,
//                 child: Container(
//                   width: double.infinity,
//                   child: BadText(
//                       '${node.depth}: ${node.expanded ? '√' : '×'} ${node.data['name']}'),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

const treeData = {
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
};

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final controller = BadTreeController<Map<String, dynamic>>();

  Set<Map<String, dynamic>> selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            // rerender the whole tree
            onPressed: () => controller.rerender(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            // collapse all nodes
            onPressed: () => controller.collapseAll(),
            icon: const Icon(Icons.unfold_less),
          ),
          IconButton(
            // expand all nodes
            onPressed: () => controller.expandAll(),
            icon: const Icon(Icons.unfold_more),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BadTree<Map<String, dynamic>>(
          controller: controller,
          tree: treeData,
          childrenProvider: (node) => node['children'],
          nodeBuilder: (node) {
            return Padding(
              padding: EdgeInsets.only(left: 16.0 * node.depth),
              child: Container(
                width: double.infinity,
                color: selected.contains(node.data)
                    ? Colors.blue.withOpacity(0.5)
                    : null,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: node.toggleExpanded,
                      icon: node.expanded
                          ? const Icon(Icons.arrow_drop_down)
                          : const Icon(Icons.arrow_right),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selected.contains(node.data)
                              ? selected.remove(node.data)
                              : selected.add(node.data);

                          // rerender subtree of the selected node
                          node.rerender();
                        },
                        child: Text(node.data['name']),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
