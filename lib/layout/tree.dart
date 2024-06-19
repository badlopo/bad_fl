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

  /// expanded state of the node
  ///
  /// Default to `true`
  bool _expanded = true;

  /// get expanded state of the node
  bool get expanded => _expanded;

  /// set expanded state of the node
  void setExpanded(bool to) {
    if (_expanded == to) {
      BadFl.log(
        module: 'BadTree',
        message: 'node is already ${to ? 'expanded' : 'collapsed'}',
      );
      return;
    }

    _setStateDelegate(() => _expanded = to);
  }

  /// toggle expanded state of the node
  void toggleExpanded() {
    _setStateDelegate(() => _expanded = !_expanded);
  }

  /// rerender the subtree of the node (including itself)
  void rerender() {
    _setStateDelegate();
  }

  /// reference to the setState function of the widget that holds the node
  void Function(VoidCallback fn)? _setState;

  void _setStateDelegate([VoidCallback fn = _noop]) {
    if (_setState == null) {
      throw Exception('Lost reference to the "setState" function');
    } else {
      _setState!(fn);
    }
  }

  TreeNode._({required this.depth, required this.data});

  @override
  String toString() {
    return '[TreeNode] <$depth> $data';
  }
}

class _BadTreeNode<TreeNodeData extends Object> extends StatefulWidget {
  final Expando<TreeNode<TreeNodeData>> _data2node;
  final Set<TreeNode<TreeNodeData>> _nodes;

  final int depth;
  final TreeNodeData data;
  final Iterable<TreeNodeData>? Function(TreeNodeData node) childrenProvider;
  final TreeNodeBuilder<TreeNodeData> nodeBuilder;

  const _BadTreeNode({
    super.key,
    required Expando<TreeNode<TreeNodeData>> data2node,
    required Set<TreeNode<TreeNodeData>> nodes,
    required this.depth,
    required this.data,
    required this.childrenProvider,
    required this.nodeBuilder,
  })  : _data2node = data2node,
        _nodes = nodes;

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
    node = widget._data2node[widget.data] ??= TreeNode<TreeNodeData>._(
      depth: widget.depth,
      data: widget.data,
    );
    // hold the reference to the setState function
    node._setState = setState;

    // add the node to the set
    widget._nodes.add(node);
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
              data2node: widget._data2node,
              nodes: widget._nodes,
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
///
/// Note: a controller can only be attached to one tree at a time
class BadTreeController<TreeNodeData extends Object> {
  bool _attached = false;
  void Function(VoidCallback fn)? _setState;
  WeakReference<Expando<TreeNode<TreeNodeData>>>? _data2node;
  WeakReference<Set<TreeNode<TreeNodeData>>>? _nodes;

  void _attach({
    required Expando<TreeNode<TreeNodeData>> data2node,
    required Set<TreeNode<TreeNodeData>> nodes,
    required void Function(VoidCallback fn) setState,
  }) {
    if (_attached) {
      throw StateError('The instance is already attached');
    }

    _data2node = WeakReference(data2node);
    _nodes = WeakReference(nodes);
    _setState = setState;
    _attached = true;
  }

  void _detach() {
    _attached = false;
    _data2node = null;
    _nodes = null;
    _setState = null;
  }

  bool _check() {
    if (!_attached) {
      throw StateError('The instance is not attached');
    }
    return true;
  }

  /// get the node of the tree by its data, return `null` if not found
  ///
  /// Note: the `data` should be the same object as the one passed to the tree widget
  TreeNode<TreeNodeData>? getTreeNodeByData(TreeNodeData data) {
    if (_check()) {
      return _data2node!.target![data];
    }
    return null;
  }

  /// rerender the tree (keeping the expanded state)
  void rerender() {
    if (_check()) {
      _setState!(() {});
    }
  }

  /// expand all nodes in the tree
  void expandAll() {
    if (_check()) {
      for (final node in _nodes!.target!) {
        node._expanded = true;
      }
      _setState!(() {});
    }
  }

  /// collapse all nodes in the tree
  void collapseAll() {
    if (_check()) {
      for (final node in _nodes!.target!) {
        node._expanded = false;
      }
      _setState!(() {});
    }
  }
}

/// tree widget
class BadTree<TreeNodeData extends Object> extends StatefulWidget {
  /// controller for tree state management
  final BadTreeController<TreeNodeData>? controller;

  /// tree data
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
  /// `data` to `node` mapping, used to store the state of the node (especially the expanded state)
  final _data2node = Expando<TreeNode<TreeNodeData>>('BadTreeNodes');

  /// all nodes in the tree, used to implement the controller
  final Set<TreeNode<TreeNodeData>> _nodes = {};

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(
      data2node: _data2node,
      nodes: _nodes,
      setState: setState,
    );
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _nodes.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BadTreeNode<TreeNodeData>(
      data2node: _data2node,
      nodes: _nodes,
      depth: 0,
      data: widget.tree,
      childrenProvider: widget.childrenProvider,
      nodeBuilder: widget.nodeBuilder,
    );
  }
}
