part of 'tree.dart';

typedef ChildrenProvider<T extends Object> = Iterable<T>? Function(
    T parent, int depth);
typedef TreeNodeBuilder<T extends Object> = Widget Function(
    BuildContext context, TreeNodeEntry<T> entry);

// region TreeNode widget
class _TreeNode<NodeData extends Object> extends StatefulWidget {
  final Expando<TreeNodeEntry<NodeData>> _nodeEntries;

  final int depth;
  final NodeData data;
  final ChildrenProvider<NodeData> childrenProvider;
  final TreeNodeBuilder<NodeData> nodeBuilder;

  const _TreeNode({
    required Expando<TreeNodeEntry<NodeData>> nodeStates,
    required this.depth,
    required this.data,
    required this.childrenProvider,
    required this.nodeBuilder,
  }) : _nodeEntries = nodeStates;

  @override
  State<_TreeNode<NodeData>> createState() => _TreeNodeState<NodeData>();
}

class _TreeNodeState<NodeData extends Object>
    extends State<_TreeNode<NodeData>> {
  late TreeNodeEntry<NodeData> entry;

  @override
  void initState() {
    super.initState();

    final cached = widget._nodeEntries[widget.data];
    if (cached == null) {
      // create a new entry and store it in the expando
      entry = TreeNodeEntry<NodeData>._(
        state: WeakReference(this),
        depth: widget.depth,
        data: widget.data,
      );
      widget._nodeEntries[widget.data] = entry;
    } else {
      // use the cached entry and update the state reference
      entry = cached;
      entry._state = WeakReference(this);
    }
  }

  @override
  void didUpdateWidget(covariant _TreeNode<NodeData> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // update the entry with the new data
    entry._update(
      state: WeakReference(this),
      depth: widget.depth,
      data: widget.data,
    );
    // store the updated entry in the expando (in case it's a new node)
    widget._nodeEntries[widget.data] = entry;
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.childrenProvider(widget.data, widget.depth + 1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.nodeBuilder(context, entry),
        if (children != null && !entry._isFold)
          for (final child in children)
            _TreeNode<NodeData>(
              nodeStates: widget._nodeEntries,
              depth: widget.depth + 1,
              data: child,
              childrenProvider: widget.childrenProvider,
              nodeBuilder: widget.nodeBuilder,
            ),
      ],
    );
  }
}
// endregion

// region BadTree widget
class BadTree<NodeData extends Object> extends StatefulWidget {
  final BadTreeController<NodeData>? controller;

  /// source data of trees
  final List<NodeData> roots;

  /// function to provide children of a node, return `null` if the node is a leaf
  final ChildrenProvider<NodeData> childrenProvider;

  /// builder for each node
  final TreeNodeBuilder<NodeData> nodeBuilder;

  const BadTree({
    super.key,
    this.controller,
    required this.roots,
    required this.childrenProvider,
    required this.nodeBuilder,
  });

  @override
  State<BadTree<NodeData>> createState() => _BadTreeState<NodeData>();
}

class _BadTreeState<NodeData extends Object> extends State<BadTree<NodeData>> {
  /// node data => widget state
  Expando<TreeNodeEntry<NodeData>> _nodeEntries = Expando();

  @override
  void didUpdateWidget(covariant BadTree<NodeData> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // clear the nodeStates if the roots or childrenProvider changed
    if (widget.roots != oldWidget.roots ||
        widget.childrenProvider != oldWidget.childrenProvider) {
      _nodeEntries = Expando();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final root in widget.roots)
          _TreeNode<NodeData>(
            nodeStates: _nodeEntries,
            depth: 0,
            data: root,
            childrenProvider: widget.childrenProvider,
            nodeBuilder: widget.nodeBuilder,
          ),
      ],
    );
  }
}
// endregion
