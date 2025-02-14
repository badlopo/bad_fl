part of 'tree.dart';

typedef ChildrenProvider<NodeData extends Object> = Iterable<NodeData>?
    Function(NodeData parent, int depth);

typedef ExpandProvider<NodeData extends Object> = bool Function(
    NodeData node, int depth);

bool kDefaultExpandProvider($1, $2) => true;

/// An object corresponding to a tree node, used to store and manage node status.
class TreeNode<NodeData extends Object> {
  final VoidCallback _relayout;
  final NodeData _data;
  final int depth;
  final List<TreeNode<NodeData>>? children;

  bool _expanded;

  NodeData get data => _data;

  bool get isExpand => _expanded;

  bool get isLeaf => children?.isNotEmpty != true;

  TreeNode._(
    this._data, {
    required VoidCallback relayout,
    required bool expanded,
    required this.depth,
    this.children,
  })  : _relayout = relayout,
        _expanded = expanded;

  void expand() {
    if (_expanded) return;

    _expanded = true;
    _relayout();
  }

  void collapse() {
    if (!_expanded) return;

    _expanded = false;
    _relayout();
  }

  void toggle() {
    _expanded = !_expanded;
    _relayout();
  }

  Map<String, dynamic> toJson() {
    return {
      'data': _data,
      'depth': depth,
      'expanded': _expanded,
      'children': children?.map((e) => e.toJson()).toList(),
    };
  }
}

class TreeController<NodeData extends Object> {
  /// A function to get children from current node,
  /// return `null` when current is a leaf node.
  final ChildrenProvider<NodeData> childrenProvider;

  /// A function to determine whether a node is expanded.
  ///
  /// Default to [kIsExpandDefault].
  final ExpandProvider<NodeData> expandProvider;

  /// A tree of [TreeNode] generated from [_tree].
  TreeNode<NodeData>? _nodeTree;

  /// The list of visible nodes. (Flattened from [_nodeTree])
  List<TreeNode<NodeData>> _visibleNodes = [];

  /// Generate a tree of [TreeNode] from raw tree data.
  TreeNode<NodeData> _generateNodeTree(NodeData nodeData, int depth) {
    // generate children before the parent node
    final children = childrenProvider(nodeData, depth)
        ?.map((child) => _generateNodeTree(child, depth + 1))
        // mark as non-growable list for few optimization
        .toList(growable: false);

    // generate parent node and return
    return TreeNode._(
      nodeData,
      relayout: _relayout,
      expanded: expandProvider(nodeData, depth),
      depth: depth,
      children: children,
    );
  }

  /// Walk through the [_nodeTree], extract all visible nodes
  /// into a list and replace [_visibleNodes] with it.
  void _extractVisibleNodes([TreeNode<NodeData>? node]) {
    // do initialization if 'node' is null (root node)
    if (node == null) {
      _visibleNodes = [];
      node = _nodeTree;
    }

    // add current node to visible nodes
    _visibleNodes.add(node!);

    // add children if current node is expanded and has children
    if (node.isExpand && node.children?.isNotEmpty == true) {
      for (final child in node.children!) {
        _extractVisibleNodes(child);
      }
    }
  }

  double _offset = 0.0;
  late final ScrollController _sc;

  WeakReference<_TreeState<NodeData>>? _state;

  /// Re-calculate visible nodes and flush UI if possible.
  void _relayout() {
    _extractVisibleNodes();

    _state?.target?.flushUI();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (_sc.hasClients && _sc.position.outOfRange) {
        _sc.jumpTo(_sc.position.maxScrollExtent);
      }
    });
  }

  TreeController({
    NodeData? tree,
    required this.childrenProvider,
    this.expandProvider = kDefaultExpandProvider,
  }) {
    if (tree != null) {
      _nodeTree = _generateNodeTree(tree, 0);
      _extractVisibleNodes();
    }

    _sc = ScrollController(
      onAttach: (pos) {
        if (_offset != 0) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => pos.jumpTo(_offset));
        }
      },
      onDetach: (pos) {
        _offset = pos.pixels;
      },
    );
  }

  void updateTree(NodeData tree) {
    _nodeTree = _generateNodeTree(tree, 0);
    _relayout();
  }
}
