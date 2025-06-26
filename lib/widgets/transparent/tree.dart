import 'package:flutter/material.dart';

/// An object corresponding to a tree node, used to store and manage node status.
class TreeNode<TreeNodeData> {
  final int depth;

  final TreeNodeData _data;

  TreeNodeData get data => _data;

  bool _expand;

  bool get isExpand => _expand;

  final List<TreeNode<TreeNodeData>>? _children;

  bool get isLeaf => _children?.isNotEmpty != true;

  TreeNode._({
    required this.depth,
    required TreeNodeData data,
    required bool expand,
    List<TreeNode<TreeNodeData>>? children,
  })  : _data = data,
        _expand = expand,
        _children = children;
}

bool _alwaysExpand($1, $2) => true;

/// Since the core logic is implemented in [BadTreeController],
/// and the control and rendering of the tree are completely decoupled,
/// you can implement the tree display yourself as needed.
class BadTreeController<TreeNodeData> extends ChangeNotifier {
  /// You can customize how to calculate the expansion state of each
  /// node in the initial state (based on the depth and data of the node).
  ///
  /// The default strategy is [_alwaysExpand].
  final bool Function(TreeNodeData node, int depth) expansionStrategy;

  /// A function that gets the child nodes from the current node,
  /// returns "null" if the current node is a leaf node.
  final Iterable<TreeNodeData>? Function(TreeNodeData node, int depth)
      childrenProvider;

  TreeNode<TreeNodeData>? _tree;

  /// Build a tree from the given data.
  TreeNode<TreeNodeData> _buildTreeFromData(TreeNodeData data, int depth) {
    // generate children before the parent node
    final children = childrenProvider(data, depth)
        ?.map((child) => _buildTreeFromData(child, depth + 1))
        // mark as non-growable list for few optimization
        .toList(growable: false);

    // generate parent node and return
    return TreeNode._(
      depth: depth,
      data: data,
      expand: expansionStrategy(data, depth),
      children: children,
    );
  }

  /// List of visible nodes in the tree. (flattened from [_tree])
  List<TreeNode<TreeNodeData>> _visibleNodes = [];

  /// NOTE: Unless you implement your own tree renderer, you probably won't need to use this.
  List<TreeNode<TreeNodeData>> get visibleNodes => _visibleNodes;

  /// Walk through the [_nodeTree], extract all visible nodes
  /// into a list and replace [_visibleNodes] with it.
  void _extractVisibleNodes([TreeNode<TreeNodeData>? node]) {
    // do initialization if 'node' is null (root node)
    if (node == null) {
      _visibleNodes = [];
      node = _tree;
    }

    // add current node to visible nodes
    _visibleNodes.add(node!);

    // add children if current node is expanded and has children
    if (node._expand && node._children?.isNotEmpty == true) {
      for (final child in node._children!) {
        _extractVisibleNodes(child);
      }
    }
  }

  BadTreeController({
    TreeNodeData? data,
    this.expansionStrategy = _alwaysExpand,
    required this.childrenProvider,
  }) {
    if (data != null) updateTree(data);
  }

  /// Update the tree with new data.
  void updateTree(TreeNodeData data) {
    _tree = _buildTreeFromData(data, 0);
    relayout();
  }

  /// Toggle the expand state of a node, than rebuild the UI.
  /// If [to] is provided, it will set the expand state to [to],
  /// otherwise it will toggle the current state.
  void toggleExpand(TreeNode<TreeNodeData> node, [bool? to]) {
    if (_tree == null) return;
    node._expand = to ?? !node._expand;
    relayout();
  }

  /// Re-calculate visible nodes and notify listeners to rebuild the UI.
  void relayout() {
    if (_tree == null) return;
    _extractVisibleNodes();
    notifyListeners();
  }
}

/// The default implementation of the tree view uses listview for simple rendering.
/// You can implement it yourself if necessary.
class BadTree<TreeNodeData> extends StatefulWidget {
  final BadTreeController<TreeNodeData> controller;
  final EdgeInsets padding;

  final Widget Function(BuildContext context, TreeNode<TreeNodeData> node)
      nodeBuilder;

  const BadTree({
    super.key,
    required this.controller,
    this.padding = EdgeInsets.zero,
    required this.nodeBuilder,
  });

  @override
  State<BadTree<TreeNodeData>> createState() => _TreeState<TreeNodeData>();
}

class _TreeState<TreeNodeData> extends State<BadTree<TreeNodeData>> {
  final ScrollController _sc = ScrollController();

  void handleUpdate() {
    setState(() {
      // since all mutations are handled inside widget.controller,
      // we only need to call setState here
    });

    // after the frame is built, we check if the scroll position is out of range,
    // if so, we jump to the end of the list.
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (_sc.hasClients && _sc.position.outOfRange) {
        _sc.jumpTo(_sc.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(handleUpdate);
  }

  @override
  void didUpdateWidget(covariant BadTree<TreeNodeData> oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.removeListener(handleUpdate);
    widget.controller.addListener(handleUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleUpdate);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _sc,
      padding: widget.padding,
      children: [
        for (final node in widget.controller.visibleNodes)
          widget.nodeBuilder(context, node),
      ],
    );
  }
}
