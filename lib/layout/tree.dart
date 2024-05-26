import 'package:bad_fl/wrapper/_wrapper.dart';
import 'package:flutter/material.dart';

// ===== ===== tree node controller ===== =====

class TreeNodeController<TreeNodeData> {
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

  /// render ui with specified expanded state
  final void Function(bool to) _renderExpanded;

  TreeNodeController._({
    required this.data,
    required void Function(bool to) renderExpanded,
  }) : _renderExpanded = renderExpanded;
}

// ===== ===== tree node widget ===== =====

class _TreeNode<TreeNodeData> extends StatefulWidget {
  final int depth;
  final TreeNodeData node;
  final List<TreeNodeData>? Function(TreeNodeData node) childrenProvider;
  final Widget Function(TreeNodeData node, int depth) nodeBuilder;
  final void Function(TreeNodeController<TreeNodeData> node)? onNodeTap;

  const _TreeNode({
    required this.depth,
    required this.node,
    required this.childrenProvider,
    required this.nodeBuilder,
    this.onNodeTap,
  });

  @override
  State<_TreeNode<TreeNodeData>> createState() =>
      _TreeNodeState<TreeNodeData>();
}

class _TreeNodeState<TreeNodeData> extends State<_TreeNode<TreeNodeData>> {
  late final TreeNodeController<TreeNodeData> controller;

  @override
  void initState() {
    super.initState();

    controller = TreeNodeController<TreeNodeData>._(
      data: widget.node,
      renderExpanded: (to) => setState(() => controller._expanded = to),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TreeNodeData>? children = widget.childrenProvider(widget.node);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.onNodeTap == null
            ? widget.nodeBuilder(widget.node, widget.depth)
            // FIXME: better strategy to handle partial click
            : BadClickable(
                child: widget.nodeBuilder(widget.node, widget.depth),
                onClick: () => widget.onNodeTap!.call(controller),
              ),
        if (controller.expanded && children != null)
          for (final child in children)
            _TreeNode(
              depth: widget.depth + 1,
              node: child,
              childrenProvider: widget.childrenProvider,
              nodeBuilder: widget.nodeBuilder,
              onNodeTap: widget.onNodeTap,
            ),
      ],
    );
  }
}

// ===== ===== tree widget ===== =====

class BadTree<TreeNodeData> extends StatefulWidget {
  /// root node of the tree
  final TreeNodeData root;

  /// function to provide children of a node, return `null` if the node is a leaf
  final List<TreeNodeData>? Function(TreeNodeData node) childrenProvider;

  /// builder for each node
  final Widget Function(TreeNodeData node, int depth) nodeBuilder;

  /// callback when a node is tapped
  final void Function(TreeNodeController<TreeNodeData> node)? onNodeTap;

  const BadTree({
    super.key,
    required this.root,
    required this.childrenProvider,
    required this.nodeBuilder,
    this.onNodeTap,
  });

  @override
  State<BadTree<TreeNodeData>> createState() => _BadTreeState<TreeNodeData>();
}

class _BadTreeState<TreeNodeData> extends State<BadTree<TreeNodeData>> {
  @override
  Widget build(BuildContext context) {
    return _TreeNode<TreeNodeData>(
      depth: 0,
      node: widget.root,
      childrenProvider: widget.childrenProvider,
      nodeBuilder: widget.nodeBuilder,
      onNodeTap: widget.onNodeTap,
    );
  }
}
