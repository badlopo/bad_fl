import 'package:flutter/material.dart';

class BadPopupController extends ChangeNotifier {
  bool visible;

  BadPopupController([initialVisible = false]) : visible = initialVisible;

  void show() {
    visible = true;
    notifyListeners();
  }

  void hide() {
    visible = false;
    notifyListeners();
  }
}

class BadPopup extends StatefulWidget {
  final BadPopupController controller;

  /// Origin of child widget.
  final Alignment origin;

  /// Origin of popup widget.
  final Alignment popupOrigin;

  /// Extra offset to apply to the popup widget.
  ///
  /// Default to [Offset.zero].
  final Offset offset;

  /// Callback when tapping outside the popup widget.
  ///
  /// If set, there will be a transparent mask when
  /// the popup-widget is shown, and all content behind
  /// it will not be clickable until it is hidden.
  final VoidCallback? onTapOutside;

  /// The popup widget.
  final Widget popup;

  /// Builder function for child widget (with visibility of the popup-widget provided).
  final Widget Function(BuildContext context, bool visible) childBuilder;

  const BadPopup({
    super.key,
    required this.controller,
    this.origin = Alignment.bottomLeft,
    this.popupOrigin = Alignment.topLeft,
    this.offset = Offset.zero,
    this.onTapOutside,
    required this.popup,
    required this.childBuilder,
  });

  @override
  State<BadPopup> createState() => _PopupState();
}

class _PopupState extends State<BadPopup> {
  final _link = LayerLink();
  late OverlayEntry _popupEntry;

  bool visible = false;

  void handleUpdate() {
    final bool to = widget.controller.visible;

    // ignore duplicate updates
    if (to == visible) return;

    if (to) {
      Overlay.of(context).insert(_popupEntry);
    } else {
      _popupEntry.remove();
    }

    // update the visible state
    setState(() {
      visible = to;
    });
  }

  @override
  void initState() {
    super.initState();

    _popupEntry = OverlayEntry(
      builder: (context) {
        Widget popupWidget = Material(
          type: MaterialType.transparency,
          child: widget.popup,
        );

        if (widget.onTapOutside != null) {
          // consume the tap event so that the 'onTapOutside'
          // callback will not be triggered inside the popup widget.
          popupWidget = GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: popupWidget,
          );
        }

        return LayoutBuilder(builder: (_, constraints) {
          final mask = UnconstrainedBox(
            child: CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              targetAnchor: widget.origin,
              followerAnchor: widget.popupOrigin,
              offset: widget.offset,
              child: ConstrainedBox(
                constraints: BoxConstraints.loose(constraints.biggest),
                child: popupWidget,
              ),
            ),
          );

          if (widget.onTapOutside == null) return mask;

          return GestureDetector(
            onTap: widget.onTapOutside,
            behavior: HitTestBehavior.opaque,
            child: mask,
          );
        });
      },
    );
    visible = widget.controller.visible;

    // insert the popup entry if it is visible at the beginning
    if (visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Overlay.of(context).insert(_popupEntry);
      });
    }

    widget.controller.addListener(handleUpdate);
  }

  @override
  void didUpdateWidget(covariant BadPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.removeListener(handleUpdate);
    widget.controller.addListener(handleUpdate);

    // NOTE: cannot directly call 'markNeedsBuild' here (during 'build')
    // so we schedule it in next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _popupEntry.markNeedsBuild();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(handleUpdate);

    // NOTE: use 'visible' to check if this meet some error ...
    if (_popupEntry.mounted) _popupEntry.remove();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: widget.childBuilder(context, visible),
    );
  }
}
