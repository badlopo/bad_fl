import 'package:bad_fl/core.dart';
import 'package:flutter/material.dart';

/// builder for each node
typedef TreeNodeBuilder<T extends Object> = Widget Function(TreeNode<T> node);

void _noop() {}

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
  void setExpanded(bool to) {
    if (_expanded == to) {
      BadFl.log('BadTree', 'expanded state is already $to');
      return;
    }

    _setStateDelegate(() {
      _expanded = to;
    });
  }

  /// toggle expanded state of the node
  void toggleExpanded() {
    _setStateDelegate(() {
      _expanded = !_expanded;
    });
  }

  /// rerender the subtree of the node (including itself)
  void rerender() {
    _setStateDelegate();
  }

  /// render ui with specified expanded state (internal)
  void Function(VoidCallback fn)? _setState;

  void _setStateDelegate([VoidCallback fn = _noop]) {
    if (_setState == null) {
      BadFl.log('BadTree', 'setState is not available now');
    } else {
      _setState!(fn);
    }
  }

  TreeNode._({required this.depth, required this.data});
}

class _BadTreeNode<TreeNodeData extends Object> extends StatefulWidget {
  final Expando<TreeNode<TreeNodeData>> nodes;

  final int depth;
  final TreeNodeData data;
  final Iterable<TreeNodeData>? Function(TreeNodeData node) childrenProvider;
  final TreeNodeBuilder<TreeNodeData> nodeBuilder;

  const _BadTreeNode({
    super.key,
    required this.nodes,
    required this.depth,
    required this.data,
    required this.childrenProvider,
    required this.nodeBuilder,
  });

  @override
  State<_BadTreeNode<TreeNodeData>> createState() =>
      _BadTreeNodeState<TreeNodeData>();
}

class _BadTreeNodeState<TreeNodeData extends Object>
    extends State<_BadTreeNode<TreeNodeData>> {
  late final TreeNode<TreeNodeData> node;

  @override
  void initState() {
    super.initState();

    // get the node from the expando, or create a new one and store it
    node = widget.nodes[widget.data] ??= TreeNode<TreeNodeData>._(
      depth: widget.depth,
      data: widget.data,
    );
    // hold the reference to the setState function
    node._setState = setState;
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
            _BadTreeNode(
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

/// controller for tree state management
class BadTreeController<TreeNodeData extends Object> {
  /// get the node of the tree by its data, return `null` if not found
  ///
  /// Note: the `data` should be the same object as the one passed to the tree widget
  TreeNode<TreeNodeData>? getTreeNodeByData(TreeNodeData data) {
    return null;
  }
}

/// tree widget
class BadTree<TreeNodeData extends Object> extends StatefulWidget {
  /// controller for tree state management
  final BadTreeController<TreeNodeData>? controller;

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
    this.controller,
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
  final nodes = Expando<TreeNode<TreeNodeData>>('BadTreeNodes');

  @override
  Widget build(BuildContext context) {
    return _BadTreeNode<TreeNodeData>(
      nodes: nodes,
      depth: 0,
      data: widget.tree,
      childrenProvider: widget.childrenProvider,
      nodeBuilder: widget.nodeBuilder,
    );
  }
}
