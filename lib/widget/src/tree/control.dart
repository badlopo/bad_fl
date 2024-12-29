part of 'tree.dart';

class TreeController<NodeData extends Object> {
  _TreeState<NodeData>? _state;

  void expandAll() {
    assert(_state != null);
    _state?.expandAll();
  }

  void collapseAll() {
    assert(_state != null);
    _state?.collapseAll();
  }
}

/// An object corresponding to a tree node, used to store and manage node status.
class TreeNode<NodeData extends Object> {
  // lopo: Is 'WeakReference' better than direct holding?
  final WeakReference<_TreeState<NodeData>> _state;
  final NodeData _data;
  final int depth;
  final List<TreeNode<NodeData>>? children;

  bool _expanded;

  NodeData get data => _data;

  bool get isExpand => _expanded;

  bool get isLeaf => children?.isNotEmpty != true;

  TreeNode._(
    this._data, {
    required WeakReference<_TreeState<NodeData>> state,
    required bool expanded,
    required this.depth,
    this.children,
  })  : _state = state,
        _expanded = expanded;

  void expand() {
    if (_expanded) return;

    _expanded = true;

    assert(_state.target != null, "Unreachable!");
    _state.target?._flush();
  }

  void collapse() {
    if (!_expanded) return;

    _expanded = false;

    assert(_state.target != null, "Unreachable!");
    _state.target?._flush();
  }

  void toggle() {
    _expanded = !_expanded;

    assert(_state.target != null, "Unreachable!");
    _state.target?._flush();
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
