import 'package:flutter/material.dart';

/// A controller for managing the expansion state of an [BadExpansible].
class BadExpansibleController extends ValueNotifier<bool> {
  /// Creates a controller for managing the expanded state of an expansible widget.
  ///
  /// The [value] parameter determines whether the expansible is initially expanded.
  ///
  /// NOTE: call `BadExpansibleController.dispose()` when you are done with the controller.
  BadExpansibleController([super._value = true]);

  bool get isExpanded => value;

  void expand() {
    value = true;
  }

  void collapse() {
    value = false;
  }

  void toggle() {
    value = !value;
  }
}

class BadExpansible extends StatefulWidget {
  /// Controller for managing the expanded state of the expansible widget.
  /// If `null`, the expansible will manage its own state internally.
  final BadExpansibleController? controller;

  /// Callback that is called when the expansible is expanded or collapsed. (Called after the animation is finished.)
  final ValueChanged<bool>? onChanged;

  /// In most cases, the header of the expansible will show different content
  /// according to whether it is expanded or not,
  /// so we accept a builder rather than a static header widget.
  final Widget Function(BadExpansibleController controller) headerBuilder;

  /// The child widget that will be displayed when the expansible is expanded.
  final Widget child;

  const BadExpansible({
    super.key,
    this.controller,
    this.onChanged,
    required this.headerBuilder,
    required this.child,
  });

  @override
  State<BadExpansible> createState() => _ExpansibleState();
}

class _ExpansibleState extends State<BadExpansible> {
  /// local controller that is used when the user did not provide one.
  BadExpansibleController? localController;

  // Set up the local controller if the user did not provide one,
  // and ensures that the local controller is created at most once.
  void setupLocalControllerIfNeeded() {
    if (widget.controller == null && localController == null) {
      localController = BadExpansibleController();
    }
  }

  BadExpansibleController get controller =>
      widget.controller ?? localController!;

  void handleUpdate() {
    setState(() {
      /** value has been changed in widget.controller */
    });
  }

  @override
  void initState() {
    super.initState();

    setupLocalControllerIfNeeded();
    controller.addListener(handleUpdate);
  }

  @override
  void didUpdateWidget(covariant BadExpansible oldWidget) {
    super.didUpdateWidget(oldWidget);

    // remove listener on the previous working controller
    (oldWidget.controller ?? localController)!.removeListener(handleUpdate);

    // ensure there is a working controller and add listener to it
    setupLocalControllerIfNeeded();
    controller.addListener(handleUpdate);
  }

  @override
  void dispose() {
    // we just dispose the local controller if it exists,
    // otherwise we assume the controller is managed by the user.
    // this is to avoid disposing the controller that is passed by the user.

    controller.removeListener(handleUpdate);
    if (localController != null) {
      localController!.dispose();
      localController = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      onEnd: () => widget.onChanged?.call(controller.isExpanded),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.headerBuilder(controller),
          if (controller.isExpanded) widget.child,
        ],
      ),
    );
  }
}
