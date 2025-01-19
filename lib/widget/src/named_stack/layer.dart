part of 'named_stack.dart';

class NamedStackLayer extends StatelessWidget {
  /// Name of layerThe name of the layer, which is expected to be unique within the same [BadNamedStack].
  final String name;
  final Widget child;

  const NamedStackLayer({super.key, required this.name, required this.child});

  @override
  Widget build(BuildContext context) => child;
}
