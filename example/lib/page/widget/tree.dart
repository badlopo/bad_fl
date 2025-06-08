import 'package:bad_fl/widgets.dart';
import 'package:flutter/material.dart';

final treeData = {
  'name': 'root',
  'children': [
    {
      'name': 'node1',
      'children': [
        {'name': 'node1-1'},
        {'name': 'node1-2'},
      ],
    },
    {
      'name': 'node2',
      'children': [
        {'name': 'node2-1'},
      ],
    },
    {
      'name': 'node3',
    },
  ],
};

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  final treeController = BadTreeController<Map<String, dynamic>>(
    data: treeData,
    childrenProvider: (node, int depth) => node['children'],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: BadTree(
                controller: treeController,
                nodeBuilder: (context, node) {
                  return BadClickable(
                    onClick: () => treeController.toggleExpand(node),
                    child: _TreeNode(node: node),
                  );
                },
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: BadTree(
                controller: treeController,
                nodeBuilder: (context, node) {
                  return BadClickable(
                    onClick: () => treeController.toggleExpand(node),
                    child: _TreeNode(node: node),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeNode extends StatelessWidget {
  final TreeNode<Map<String, dynamic>> node;

  const _TreeNode({required this.node});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(node.depth * 16, 4, 0, 4),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          node.isExpand
              ? const Icon(Icons.keyboard_arrow_down)
              : const Icon(Icons.keyboard_arrow_right),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BadText(node.data['name']),
                BadText(
                  '· ${node.isLeaf ? '是' : '不是'}叶子节点',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                BadText(
                  '· 节点层级: ${node.depth}',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
