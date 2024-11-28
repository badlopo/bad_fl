import 'package:bad_fl/ext/src/iterable.dart';
import 'package:flutter/material.dart';

class NamedStackController extends ChangeNotifier {
  String _active = '';

  String get active => _active;

  set active(String to) {
    if (to == _active) return;

    _active = to;
    notifyListeners();
  }
}

/// Like [IndexedStack] but with named layers.
///
/// Note: dynamically updating 'layers' is not supported yet. (Cause `didUpdateWidget` is not overridden)
class BadNamedStack extends StatefulWidget {
  /// Controller to control the active layer.
  final NamedStackController? controller;

  /// Name of active layer to be shown initially.
  /// If the name is not a key of [layers], the first layer will be the default active layer.
  ///
  /// Use [controller] to change the active layer dynamically.
  final String active;

  /// Layers to be stacked.
  final Map<String, Widget> layers;

  const BadNamedStack({
    super.key,
    this.controller,
    required this.active,
    required this.layers,
  }) : assert(layers.length > 0, 'Think twice!');

  @override
  State<BadNamedStack> createState() => _NamedStackState();
}

class _NamedStackState extends State<BadNamedStack> {
  List<Widget> layers = [];
  Map<String, int> mapper = {};

  int index = 0;

  void _buildStack() {
    final List<Widget> newLayers = [];
    final Map<String, int> newMapper = {};
    for (final (index, entry) in widget.layers.entries.enumerate) {
      // if use `layers[index]` in build method, all layers required to be keyed.
      // newLayers.add(KeyedSubtree(key: ValueKey(index), child: entry.value));
      newLayers.add(entry.value);
      newMapper[entry.key] = index;
    }

    setState(() {
      layers = newLayers;
      mapper = newMapper;
      index = mapper[widget.active] ?? 0;
    });
  }

  void _updateActive() {
    final int? toIndex = mapper[widget.controller!._active];
    if (toIndex != null) {
      setState(() {
        index = toIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // sync 'active' after attached
    if (widget.controller != null) {
      widget.controller!._active = widget.active;
      widget.controller!.addListener(_updateActive);
    }

    _buildStack();
  }

  // uncomment this to enable switching layers by changing 'active' prop in 'setState',
  // otherwise, the active layer can only be changed by 'controller'
  // @override
  // void didUpdateWidget(covariant BadNamedStack oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _buildStack();
  // }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(_updateActive);
      widget.controller!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // this will lose the state of layers
    // return layers[index];
    return IndexedStack(index: index, children: layers);
  }
}
