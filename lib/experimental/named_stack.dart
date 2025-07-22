import 'package:flutter/material.dart';

class _NamedStackManager {
  /// name of activated layers
  final Set<String> activated = {};

  /// name to index
  Map<String, int> mapping = {};

  final VoidCallback buildMapping;
  final VoidCallback flushUI;

  _NamedStackManager({required this.buildMapping, required this.flushUI});

  void register(String name) {
    buildMapping();
    flushUI();
  }

  void deregister(String name) {
    activated.remove(name);
    buildMapping();
    flushUI();
  }
}

/// context provider
class _NamedStackScope extends InheritedWidget {
  final _NamedStackManager manager;

  const _NamedStackScope({required this.manager, required super.child});

  @override
  bool updateShouldNotify(covariant _NamedStackScope oldWidget) {
    return manager != oldWidget.manager;
  }
}

class BadNamedStackLayer extends StatefulWidget {
  /// The name of the layer, which is expected to be unique within the same [BadNamedStack].
  final String name;
  final Widget child;

  const BadNamedStackLayer({
    super.key,
    required this.name,
    required this.child,
  });

  @override
  State<BadNamedStackLayer> createState() => _NamedStackLayerState();
}

class _NamedStackLayerState extends State<BadNamedStackLayer> {
  _NamedStackManager? manager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    manager =
        context.getInheritedWidgetOfExactType<_NamedStackScope>()?.manager;
    assert(
      manager != null,
      'BadNamedStackLayer can only be used in "BadNamedStack"',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      manager!.register(widget.name);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      manager?.deregister(widget.name);
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Similar to `IndexedStack` but uses name instead of index to control the activated page,
/// and its children are lazy loaded (activated and built only when they are first visited).
///
/// About [layers]:
/// - Const layers: recommended. Since layers will not change, there will be no problems.
/// - Non-const layers: it works normally, but it will trigger layers's `didUpdateWidget` when the parent component is rebuilt.
/// - Dynamic modification of layers: it is best not to use it. Whether it is insertion, deletion, replacement, or exchange, it will cause unexpected reconstruction. The originally activated child may become inactivated (depending on the previous and next positions and their `runtimeType`).
///   It is complicated to describe this change rule, so take responsibility yourself.
class BadNamedStack extends StatefulWidget {
  final String name;

  final List<BadNamedStackLayer> layers;

  /// see [Stack.alignment]
  final AlignmentGeometry alignment;

  /// see [Stack.textDirection]
  final TextDirection? textDirection;

  /// see [Stack.clipBehavior]
  final Clip clipBehavior;

  /// see [Stack.fit]
  final StackFit fit;

  const BadNamedStack({
    super.key,
    required this.name,
    required this.layers,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.fit = StackFit.loose,
  });

  @override
  State<BadNamedStack> createState() => _NamedStackState();
}

class _NamedStackState extends State<BadNamedStack> {
  late final _NamedStackManager manager;

  void buildMapping() {
    // rebuild mapping
    manager.mapping = {
      for (final (index, layer) in widget.layers.indexed) layer.name: index
    };

    // activate current layer if exists
    if (manager.mapping.containsKey(widget.name)) {
      manager.activated.add(widget.name);
    }
  }

  @override
  void initState() {
    super.initState();

    manager = _NamedStackManager(
      buildMapping: buildMapping,
      flushUI: () {
        setState(() {});
      },
    );
    buildMapping();
  }

  @override
  void didUpdateWidget(covariant BadNamedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    buildMapping();
  }

  @override
  Widget build(BuildContext context) {
    return _NamedStackScope(
      manager: manager,
      child: Stack(
        alignment: widget.alignment,
        textDirection: widget.textDirection,
        fit: widget.fit,
        clipBehavior: widget.clipBehavior,
        children: [
          for (final layer in widget.layers)
            Offstage(
              offstage: widget.name != layer.name,
              child: manager.activated.contains(layer.name)
                  ? layer
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
