import 'package:bad_fl/core.dart';
import 'package:flutter/material.dart';

class NamedStackController extends ChangeNotifier {
  /// supported layer names
  Set<String>? _candidates;

  /// name of active layer
  String _active;

  /// name of active layer
  String get active => _active;

  /// update active layer by name
  set active(String v) {
    // filter
    if (_active == v) return;

    // check if the name is supported, directly pass if instance has not attached
    if (_candidates != null && !_candidates!.contains(v)) {
      throw UnsupportedError('unsupported name "$v", expected $_candidates');
    }

    // update & notify
    _active = v;
    notifyListeners();
  }

  /// [defaultActive] is the name of the default active layer,
  /// if the name is not provided by stack, the first layer will be the default active layer.
  NamedStackController(String defaultActive) : _active = defaultActive;
}

/// like [IndexedStack] but with named layers
class NamedStack extends StatefulWidget {
  /// controller to manage the active layer
  final NamedStackController controller;

  /// layers to be stacked
  final Map<String, Widget> stack;

  const NamedStack({
    super.key,
    required this.controller,
    required this.stack,
  }) : assert(stack.length != 0, 'stack must not be empty');

  @override
  State<NamedStack> createState() => _NamedStackState();
}

class _NamedStackState extends State<NamedStack> {
  int index = 0;

  final Map<String, int> _name2index = {};
  final List<Widget> layers = [];

  void syncActive() {
    // we applied guards to the setter of 'active' so that
    // we can ensure that we can index the value here.
    final int i = _name2index[widget.controller.active]!;

    if (index == i) return;
    setState(() => index = i);
  }

  @override
  void initState() {
    super.initState();

    final Set<String> candidates = {};
    int i = 0;
    widget.stack.forEach((k, v) {
      candidates.add(k);
      _name2index[k] = i;
      layers.add(v);
      i += 1;
    });

    index = _name2index[widget.controller.active] ?? 0;
    widget.controller._candidates = candidates;
    widget.controller.addListener(syncActive);
  }

  @override
  void dispose() {
    widget.controller.removeListener(syncActive);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return IndexedStack(index: index, children: layers);
    return layers[index];
  }
}
