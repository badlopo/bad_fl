part of 'tree.dart';

typedef ChildrenProvider<NodeData extends Object> = Iterable<NodeData>?
    Function(NodeData parent, int depth);

typedef IsExpand<NodeData extends Object> = bool Function(
    NodeData node, int depth);

bool kIsExpandDefault($1, $2) => true;

typedef NodeViewBuilder<T extends Object> = Widget Function(TreeNode<T> node);

class BadTree<NodeData extends Object> extends StatefulWidget {
  final TreeController<NodeData> controller;

  final EdgeInsets padding;

  /// The source data of tree.
  final NodeData tree;

  /// A function to determine whether a node is expanded.
  ///
  /// Default to [kIsExpandDefault].
  final IsExpand<NodeData> isExpand;

  /// A function to get children from current node,
  /// return `null` when current is a leaf node.
  final ChildrenProvider<NodeData> childrenProvider;

  /// A builder from [TreeNode] to [Widget].
  final NodeViewBuilder<NodeData> treeNodeViewBuilder;

  const BadTree({
    super.key,
    required this.controller,
    this.padding = EdgeInsets.zero,
    required this.tree,
    this.isExpand = kIsExpandDefault,
    required this.childrenProvider,
    required this.treeNodeViewBuilder,
  });

  @override
  State<BadTree<NodeData>> createState() => _TreeState<NodeData>();
}

class _TreeState<NodeData extends Object> extends State<BadTree<NodeData>> {
  /// The tree of [TreeNode] generated from [widget.tree].
  late TreeNode<NodeData> _nodeTree;

  /// The list of visible nodes. (Flattened from [_nodeTree])
  late List<TreeNode<NodeData>> _visibleNodes;

  /// Generate a tree of [TreeNode] from [widget.tree].
  TreeNode<NodeData> _generateNodeTree({
    NodeData? nodeData,
    int depth = 0,
  }) {
    // root node
    nodeData ??= widget.tree;

    // generate children before the parent node
    final children = widget
        .childrenProvider(nodeData, depth)
        ?.map((child) => _generateNodeTree(nodeData: child, depth: depth + 1))
        // mark as non-growable list (few optimization)
        .toList(growable: false);

    // generate parent node and return
    return TreeNode._(
      nodeData,
      state: WeakReference(this),
      expanded: widget.isExpand(nodeData, depth),
      depth: depth,
      children: children,
    );
  }

  /// Walk through the [_nodeTree], extract all visible nodes
  /// into a list and replace [_visibleNodes] with it.
  void _extractVisibleNodes([TreeNode<NodeData>? node]) {
    // do initialization if [node] is null (root node)
    if (node == null) {
      _visibleNodes = [];
      node = _nodeTree;
    }

    // add current node to visible nodes
    _visibleNodes.add(node);

    // add children if current node is expanded and has children
    if (node.isExpand && node.children?.isNotEmpty == true) {
      for (final child in node.children!) {
        _extractVisibleNodes(child);
      }
    }
  }

  /// Flushes changes to node visibility into the UI.
  ///
  /// this will be called in [TreeNode].
  void _flush() {
    setState(() {
      _extractVisibleNodes();
    });
  }

  void _markAsExpand([TreeNode<NodeData>? node]) {
    if (node == null) {
      _visibleNodes = [];
      node = _nodeTree;
    }

    node._expanded = true;
    _visibleNodes.add(node);

    if (node.children?.isNotEmpty == true) {
      for (final child in node.children!) {
        _markAsExpand(child);
      }
    }
  }

  void _markAsCollapse([TreeNode<NodeData>? node]) {
    if (node == null) {
      _visibleNodes = [_nodeTree];
      node = _nodeTree;
    }

    node._expanded = false;
    if (node.children?.isNotEmpty == true) {
      for (final child in node.children!) {
        _markAsCollapse(child);
      }
    }
  }

  void expandAll() {
    setState(() {
      _markAsExpand();
    });
  }

  void collapseAll() {
    setState(() {
      _markAsCollapse();
    });
  }

  @override
  void initState() {
    super.initState();

    _nodeTree = _generateNodeTree();
    _extractVisibleNodes();

    assert(
      widget.controller._state == null,
      'The provided TreeController is already associated with another BadTree.'
      'A TreeController can only be associated with one BadTree',
    );
    widget.controller._state = this;
  }

  @override
  void activate() {
    super.activate();
    widget.controller._state = this;
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.controller._state = null;
  }

  @override
  void didUpdateWidget(covariant BadTree<NodeData> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      // clean up old one
      widget.controller._state = null;

      // setup new one
      assert(
        widget.controller._state == null,
        'The provided TreeController is already associated with another BadTree.'
        'A TreeController can only be associated with one BadTree',
      );
      widget.controller._state = this;
    }

    _nodeTree = _generateNodeTree();
    _extractVisibleNodes();
  }

  @override
  void dispose() {
    widget.controller._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: widget.padding,
      children: [
        for (final node in _visibleNodes) widget.treeNodeViewBuilder(node),
      ],
    );
  }
}
