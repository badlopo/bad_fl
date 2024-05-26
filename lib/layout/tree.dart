import 'package:flutter/material.dart';

/// builder for each node
typedef TreeNodeBuilder<T> = Widget Function(TreeNode<T> node);

/// representation of a node in the tree
class TreeNode<TreeNodeData> {
  /// depth of the node (root node is at depth 0)
  final int depth;

  /// inner data of the node
  final TreeNodeData data;

  /// expanded state of the node (internal)
  ///
  /// Default to `true`
  bool _expanded = true;

  /// get expanded state of the node
  bool get expanded => _expanded;

  /// set expanded state of the node
  set expanded(bool to) {
    if (_expanded == to) return;
    _renderExpanded(to);
  }

  /// toggle expanded state of the node
  void toggleExpanded() {
    _renderExpanded(!_expanded);
  }

  /// render ui with specified expanded state (internal)
  final void Function(bool to) _renderExpanded;

  TreeNode._({
    required this.depth,
    required this.data,
    required void Function(bool to) renderExpanded,
  }) : _renderExpanded = renderExpanded;
}

class BadTreeNode<TreeNodeData> extends StatefulWidget {
  final int depth;
  final TreeNodeData data;
  final List<TreeNodeData>? Function(TreeNodeData node) childrenProvider;
  final TreeNodeBuilder<TreeNodeData> nodeBuilder;

  const BadTreeNode({
    super.key,
    required this.depth,
    required this.data,
    required this.childrenProvider,
    required this.nodeBuilder,
  });

  @override
  State<BadTreeNode<TreeNodeData>> createState() =>
      BadTreeNodeState<TreeNodeData>();
}

class BadTreeNodeState<TreeNodeData> extends State<BadTreeNode<TreeNodeData>> {
  late final TreeNode<TreeNodeData> controller;

  @override
  void initState() {
    super.initState();

    controller = TreeNode<TreeNodeData>._(
      depth: widget.depth,
      data: widget.data,
      renderExpanded: (to) => setState(() => controller._expanded = to),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TreeNodeData>? children = widget.childrenProvider(widget.data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.nodeBuilder(controller),
        if (controller.expanded && children != null)
          for (final child in children)
            BadTreeNode(
              depth: widget.depth + 1,
              data: child,
              childrenProvider: widget.childrenProvider,
              nodeBuilder: widget.nodeBuilder,
            ),
      ],
    );
  }
}

class BadTree<TreeNodeData> extends StatelessWidget {
  /// root node of the tree
  final TreeNodeData tree;

  /// function to provide children of a node, return `null` if the node is a leaf
  final List<TreeNodeData>? Function(TreeNodeData node) childrenProvider;

  /// builder for each node
  final TreeNodeBuilder<TreeNodeData> nodeBuilder;

  const BadTree({
    super.key,
    required this.tree,
    required this.childrenProvider,
    required this.nodeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BadTreeNode<TreeNodeData>(
      depth: 0,
      data: tree,
      childrenProvider: childrenProvider,
      nodeBuilder: nodeBuilder,
    );
  }
}

class BadTree2<TreeNodeData> extends StatefulWidget {
  /// root node of the tree
  final TreeNodeData root;

  /// function to provide children of a node, return `null` if the node is a leaf
  final List<TreeNodeData>? Function(TreeNodeData node) childrenProvider;

  /// builder for each node
  final TreeNodeBuilder<TreeNodeData> nodeBuilder;

  const BadTree2({
    super.key,
    required this.root,
    required this.childrenProvider,
    required this.nodeBuilder,
  });

  @override
  State<BadTree2<TreeNodeData>> createState() => _BadTree2State<TreeNodeData>();
}

class _BadTree2State<TreeNodeData> extends State<BadTree2<TreeNodeData>> {
  @override
  Widget build(BuildContext context) {
    return BadTreeNode<TreeNodeData>(
      depth: 0,
      data: widget.root,
      childrenProvider: widget.childrenProvider,
      nodeBuilder: widget.nodeBuilder,
    );
  }
}
