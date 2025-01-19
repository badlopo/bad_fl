part of 'named_stack.dart';

class NamedStackController {
  final String? initialLayer;

  _NamedStackState? _state;

  NamedStackController([this.initialLayer]);

  /// Specify the active layer by name, return if the target layer exists.
  bool setLayer(String name) {
    assert(_state != null);
    return _state!.setLayer(name);
  }
}
