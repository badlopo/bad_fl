import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

const tree = {
  "title": "root",
  "desc": "this is root node",
  "children": [
    {"title": "child1", "desc": "this is child1 node"},
    {
      "title": "child2",
      "desc": "this is child2 node",
      "children": [
        {"title": "child2-1", "desc": "this is child2-1 node"},
        {"title": "child2-2", "desc": "this is child2-2 node"}
      ]
    },
    {
      "title": "child3",
      "desc": "this is child3 node",
      "children": [
        {"title": "child3-1", "desc": "this is child3-1 node"},
        {
          "title": "child3-2",
          "desc": "this is child3-2 node",
          "children": [
            {"title": "child3-2-1", "desc": "this is child3-2-1 node"},
            {"title": "child3-2-2", "desc": "this is child3-2-2 node"}
          ]
        }
      ]
    }
  ]
};

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  final ScrollController sc = ScrollController();

  final tc = TreeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BadTree'),
        actions: [
          TextButton(
            onPressed: () => tc.collapseAll(),
            child: const Text('Collapse All'),
          ),
          TextButton(
            onPressed: () => tc.expandAll(),
            child: const Text('Expand All'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BadTree(
          controller: tc,
          tree: tree,
          childrenProvider: (node, depth) =>
              node['children'] as List<Map<String, Object>>?,
          treeNodeViewBuilder: (node) {
            return BadClickable(
              onClick: node.toggle,
              child: Container(
                width: double.infinity,
                height: 36,
                margin: EdgeInsets.only(bottom: 8, left: node.depth * 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[node.depth * 100 + 100],
                ),
                child: Row(
                  children: [
                    RotatedBox(
                      quarterTurns: node.isExpand ? 1 : 0,
                      child: const Icon(Icons.arrow_right),
                    ),
                    Expanded(
                      child: Text(
                        'Click to toggle. (${node.data['title']}, ${node.isExpand ? 'open' : 'close'} ${node.isLeaf ? ', leaf' : ''})',
                        style: const TextStyle(fontSize: 14),
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
