part of 'tree.dart';

class BadTreeController<TreeData extends Object> {
  void foldAll() {
    throw UnimplementedError();
  }

  void unfoldAll() {
    throw UnimplementedError();
  }
}

/// representation of a node in the tree
class TreeNodeEntry<NodeData extends Object> {
  late WeakReference<State> _state;

  /// depth of the node (0 for root node)
  final int depth;

  NodeData _data;

  /// data of the node
  NodeData get data => _data;

  bool _isFold = false;

  /// whether the node is folded
  ///
  /// Default to `false`
  bool get isFold => _isFold;

  /// set the fold state of the node to [to]
  void setFold(bool to) {
    _state.target?.setState(() {
      _isFold = to;
    });
  }

  /// toggle the fold state of the node
  void toggle() {
    _state.target?.setState(() {
      _isFold = !_isFold;
    });
  }

  /// apply an updater to the node data and refresh ui
  void update(void Function(NodeData data) updater) {
    _state.target?.setState(() {
      updater(_data);
    });
  }

  /// refresh the node (rerender)
  void refresh() {
    _state.target?.setState(() {});
  }

  /// private constructor
  TreeNodeEntry._({
    required WeakReference<State> state,
    required this.depth,
    required NodeData data,
  })  : _state = state,
        _data = data;

  /// update the node with new dat
  ///
  /// Note: internal use only (in `didUpdateWidget`)
  void _update({
    required WeakReference<State> state,
    required int depth,
    required NodeData data,
  }) {
    _state = state;
    _isFold = false;
    _data = data;
  }

  @override
  String toString() {
    return '[TreeNodeEntry] lv$depth (${_isFold ? 'fold' : 'unfold'})';
  }
}
