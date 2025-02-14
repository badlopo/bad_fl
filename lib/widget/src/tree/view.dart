part of 'tree.dart';

typedef NodeViewBuilder<T extends Object> = Widget Function(TreeNode<T> node);

class BadTree<NodeData extends Object> extends StatefulWidget {
  final TreeController<NodeData> controller;
  final EdgeInsets padding;

  /// A builder from [TreeNode] to [Widget].
  final NodeViewBuilder<NodeData> nodeViewBuilder;

  const BadTree({
    super.key,
    required this.controller,
    this.padding = EdgeInsets.zero,
    required this.nodeViewBuilder,
  });

  @override
  State<BadTree<NodeData>> createState() => _TreeState<NodeData>();
}

class _TreeState<NodeData extends Object> extends State<BadTree<NodeData>> {
  void flushUI() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller._state = WeakReference(this);
  }

  @override
  void activate() {
    super.activate();
    widget.controller._state = WeakReference(this);
  }

  @override
  void didUpdateWidget(covariant BadTree<NodeData> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller._state = WeakReference(this);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller._sc,
      padding: widget.padding,
      children: [
        for (final node in widget.controller._visibleNodes)
          widget.nodeViewBuilder(node),
      ],
    );
  }
}
