import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BadPopupController {
  OverlayEntry? _entry;
  VoidCallback? _show;

  /// Rebuild the popup widget.
  void rebuild() {
    if (_entry == null) {
      throw StateError('BadPopupController not attached to any BadPopup');
    }
    _entry!.markNeedsBuild();
  }

  /// Show the popup widget.
  ///
  /// This will do nothing if the popup widget is already shown.
  void show() {
    if (_entry == null) {
      throw StateError('BadPopupController not attached to any BadPopup');
    }

    // ignore if already mounted
    if (_entry!.mounted) return;

    // show the popup
    _show!();
  }

  /// Hide the popup widget.
  ///
  /// This will do nothing if the popup widget is already hidden.
  void hide() {
    if (_entry == null) {
      throw StateError('BadPopupController not attached to any BadPopup');
    }

    // ignore if not mounted
    if (!_entry!.mounted) return;

    // hide the popup
    _entry!.remove();
  }

  @protected
  void dispose() {
    if (_entry == null) return;

    if (_entry!.mounted) _entry!.remove();
    _entry!.dispose();
    _entry = null;
    _show = null;
  }
}

/// Attach a popup widget to a child widget.
/// And use [BadPopupController] to control the popup widget.
class BadPopup extends StatefulWidget {
  final BadPopupController controller;

  /// Anchor widget.
  final Widget child;

  /// Popup widget.
  final Widget popup;

  /// The anchor point on child widget.
  final Alignment targetAnchor;

  /// The anchor point on popup widget.
  final Alignment popupAnchor;

  /// Extra offset to apply to the popup widget.
  ///
  /// Default to [Offset.zero].
  final Offset offset;

  const BadPopup({
    super.key,
    required this.controller,
    required this.child,
    required this.popup,
    this.offset = Offset.zero,
    this.targetAnchor = Alignment.bottomLeft,
    this.popupAnchor = Alignment.topLeft,
  });

  @override
  State<BadPopup> createState() => _PopupState();
}

class _PopupState extends State<BadPopup> {
  /// a [LayerLink] shared by [CompositedTransformTarget] and [CompositedTransformFollower]
  final LayerLink _link = LayerLink();

  late final OverlayEntry entry;

  @override
  void initState() {
    super.initState();

    entry = OverlayEntry(
      // by default, the `OverlayEntry` is full screen,
      // so we wrap the child with `Positioned` to avoid stretching.
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            offset: widget.offset,
            targetAnchor: widget.targetAnchor,
            followerAnchor: widget.popupAnchor,
            // wrap the popup widget with `Material` to apply the theme,
            // and use `MaterialType.transparency` to avoid extra effects.
            child: Material(
              type: MaterialType.transparency,
              child: widget.popup,
            ),
          ),
        );
      },
    );

    widget.controller._entry = entry;
    widget.controller._show = () => Overlay.of(context).insert(entry);
  }

  @override
  void didUpdateWidget(covariant BadPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    // OPTIMIZE: (dev) sync UI issue
    // The ui of [popup] widget is NOT very sync during
    // development (by hot reload), usually one step behind.
    // Here we force to rebuild the entry to fix this issue in debug mode.
    // Not elegant, but works.
    if (kDebugMode) {
      // filter out the case that the popup is not mounted (unnecessary rebuild)
      if (!entry.mounted) return;

      // mark as dirty to rebuild the entry
      Future.microtask(() {
        entry.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _link, child: widget.child);
  }
}
