import 'package:flutter/material.dart';

/// builder for each node
typedef TreeNodeBuilder<T extends Object> = Widget Function(TreeNode<T> node);

/// representation of a node in the tree
class TreeNode<TreeNodeData extends Object> {
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
    _renderExpanded!(to);
  }

  /// toggle expanded state of the node
  void toggleExpanded() {
    _renderExpanded!(!_expanded);
  }

  /// render ui with specified expanded state (internal)
  void Function(bool to)? _renderExpanded;

  TreeNode._({required this.depth, required this.data});
}

// TODO: make it private
/// tree node widget
class BadTreeNode<TreeNodeData extends Object> extends StatefulWidget {
  final Expando<TreeNode<TreeNodeData>> nodes;
  final int depth;
  final TreeNodeData data;
  final Iterable<TreeNodeData>? Function(TreeNodeData node) childrenProvider;
  final TreeNodeBuilder<TreeNodeData> nodeBuilder;

  const BadTreeNode({
    super.key,
    required this.nodes,
    required this.depth,
    required this.data,
    required this.childrenProvider,
    required this.nodeBuilder,
  });

  @override
  State<BadTreeNode<TreeNodeData>> createState() =>
      BadTreeNodeState<TreeNodeData>();
}

class BadTreeNodeState<TreeNodeData extends Object>
    extends State<BadTreeNode<TreeNodeData>> {
  late final TreeNode<TreeNodeData> node;

  @override
  void initState() {
    super.initState();

    // get the node from the expando, or create a new one and store it
    node = widget.nodes[widget.data] ??= TreeNode<TreeNodeData>._(
      depth: widget.depth,
      data: widget.data,
    );
    // update function that renders expanded state
    node._renderExpanded = (to) => setState(() => node._expanded = to);
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.childrenProvider(widget.data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.nodeBuilder(node),
        if (node.expanded && children != null)
          for (final child in children)
            BadTreeNode(
              nodes: widget.nodes,
              depth: widget.depth + 1,
              data: child,
              childrenProvider: widget.childrenProvider,
              nodeBuilder: widget.nodeBuilder,
            ),
      ],
    );
  }
}

/// tree widget
class BadTree<TreeNodeData extends Object> extends StatefulWidget {
  // TODO: BadTreeController for tree state management

  /// root node of the tree
  final TreeNodeData tree;

  /// function to provide children of a node, return `null` if the node is a leaf
  ///
  /// Note: Since we use `Expando` to store the state of the node, this function should be idempotent
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
  State<BadTree<TreeNodeData>> createState() => _BadTreeState<TreeNodeData>();
}

class _BadTreeState<TreeNodeData extends Object>
    extends State<BadTree<TreeNodeData>> {
  /// nodes state
  final nodes = Expando<TreeNode<TreeNodeData>>();

  @override
  Widget build(BuildContext context) {
    return BadTreeNode<TreeNodeData>(
      nodes: nodes,
      depth: 0,
      data: widget.tree,
      childrenProvider: widget.childrenProvider,
      nodeBuilder: widget.nodeBuilder,
    );
  }
}
