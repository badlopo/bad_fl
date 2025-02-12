import 'package:flutter/material.dart';

class PopupController {
  _PopupState? _state;

  bool? get visible => _state?.visible;

  void show() {
    assert(_state != null, 'controller is not attached to any popup');
    _state?.show();
  }

  void hide() {
    assert(_state != null, 'controller is not attached to any popup');
    _state?.hide();
  }
}

typedef PopupChildBuilder = Widget Function(BuildContext context, bool visible);

class BadPopup extends StatefulWidget {
  final PopupController controller;

  /// Callback when a tap event is detected outside the popup widget.
  ///
  /// If set, there will be a transparent mask that prevents
  /// items visually behind them from receiving tap event.
  final VoidCallback? onClickOut;

  /// Whether rebuild popup widget when show.
  final bool rebuildOnVisible;

  /// Builder function for child widget (with visibility of the popup-widget provided).
  final PopupChildBuilder childBuilder;

  /// The popup widget.
  final Widget popup;

  /// Origin of child widget.
  final Alignment childOrigin;

  /// Origin of popup widget.
  final Alignment popupOrigin;

  /// Extra offset to apply to the popup widget.
  ///
  /// Default to [Offset.zero].
  final Offset popupOffset;

  const BadPopup({
    super.key,
    required this.controller,
    this.rebuildOnVisible = false,
    this.onClickOut,
    required this.childBuilder,
    required this.popup,
    this.childOrigin = Alignment.bottomLeft,
    this.popupOrigin = Alignment.topLeft,
    this.popupOffset = Offset.zero,
  });

  @override
  State<BadPopup> createState() => _PopupState();
}

class _PopupState extends State<BadPopup> {
  /// a [LayerLink] shared by [CompositedTransformTarget] and [CompositedTransformFollower]
  final LayerLink _link = LayerLink();

  late OverlayEntry entry;

  bool get visible => entry.mounted;

  void show() {
    if (visible) return;

    Overlay.of(context).insert(entry);
    if (widget.rebuildOnVisible) entry.markNeedsBuild();
    setState(() {});
  }

  void hide() {
    if (!visible) return;

    entry.remove();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    entry = OverlayEntry(builder: (_) {
      final clickOutHandler = widget.onClickOut;

      Widget popupWidget = Material(
        type: MaterialType.transparency,
        child: widget.popup,
      );

      if (clickOutHandler != null) {
        // consume tap event on popup widget
        popupWidget = GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.deferToChild,
          child: popupWidget,
        );
      }

      return LayoutBuilder(builder: (_, constraints) {
        final maskWidget = UnconstrainedBox(
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: widget.childOrigin,
            followerAnchor: widget.popupOrigin,
            offset: widget.popupOffset,
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(constraints.biggest),
              child: popupWidget,
            ),
          ),
        );

        if (clickOutHandler == null) return maskWidget;

        // it will prevent items visually behind them from receiving tap event
        return GestureDetector(
          onTap: clickOutHandler,
          behavior: HitTestBehavior.translucent,
          child: maskWidget,
        );
      });
    });
    widget.controller._state = this;
  }

  @override
  void didUpdateWidget(covariant BadPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      // release reference to self held by detached controller
      oldWidget.controller._state = null;
    }

    // NOTE: cannot directly call 'markNeedsBuild' here (during 'build')
    // so we schedule it in microtask.
    Future.microtask(() => entry.markNeedsBuild());
  }

  @override
  void dispose() {
    hide();
    widget.controller._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: widget.childBuilder(context, true),
    );
  }
}
