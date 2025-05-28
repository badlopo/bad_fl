part of 'named_stack.dart';

class BadNamedStack extends StatefulWidget {
  final NamedStackController controller;

  final List<NamedStackLayer> layers;

  const BadNamedStack({
    super.key,
    required this.controller,
    required this.layers,
  }) : assert(layers.length > 0);

  @override
  State<BadNamedStack> createState() => _NamedStackState();
}

class _NamedStackState extends State<BadNamedStack> {
  int activeIndex = 0;

  /// layer name => stack index
  Map<String, int> mapping = {};

  /// Set active layer to layer with given [name],
  /// return if target layer exists.
  bool setLayer(String name) {
    final int? to = mapping[name];
    if (to == null) return false;

    setState(() {
      activeIndex = to;
    });
    return true;
  }

  /// Regenerate mapping from layer name to stack index.
  void _rebuildMapping() {
    final newMapping = <String, int>{};
    for (final (index, layer) in widget.layers.enumerate) {
      assert(!newMapping.containsKey(layer.name), "Duplicate layer name");
      newMapping[layer.name] = index;
    }
    mapping = newMapping;
  }

  @override
  void initState() {
    super.initState();
    _rebuildMapping();

    widget.controller._state = this;
    final int? initialActiveIndex = mapping[widget.controller.initialLayer];
    if (initialActiveIndex != null) activeIndex = initialActiveIndex;
  }

  @override
  void didUpdateWidget(covariant BadNamedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.layers != oldWidget.layers) {
      _rebuildMapping();
    }

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller._state = null;
      widget.controller._state = this;

      final int? initialActiveIndex = mapping[widget.controller.initialLayer];
      if (initialActiveIndex != null) activeIndex = initialActiveIndex;
    }
  }

  @override
  void dispose() {
    widget.controller._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXME: cache layer's state rather than rebuild on switch
    return widget.layers[activeIndex];
  }
}
