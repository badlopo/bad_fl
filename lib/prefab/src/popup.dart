import 'package:flutter/material.dart';

class BadPopupController {
  OverlayEntry? _entry;
  VoidCallback? _show;

  /// rebuild the popup widget
  void rebuild() {
    if (_entry == null) {
      throw StateError('BadPopupController not attached to any BadPopup');
    }
    _entry!.markNeedsBuild();
  }

  /// show the popup widget
  ///
  /// you can call this method multiple times, it will only show the popup once
  void show() {
    if (_entry == null) {
      throw StateError('BadPopupController not attached to any BadPopup');
    }

    // ignore if already mounted
    if (_entry!.mounted) return;

    // show the popup
    _show!();
  }

  /// hide the popup widget
  void hide() async {
    if (_entry == null) {
      throw StateError('BadPopupController not attached to any BadPopup');
    }

    // ignore if not mounted
    if (!_entry!.mounted) return;

    // hide the popup
    _entry!.remove();
  }
}

class BadPopup extends StatefulWidget {
  final BadPopupController controller;

  /// anchor widget
  final Widget child;

  /// popup widget
  final Widget popup;

  /// anchor position of child widget
  final Alignment targetAnchor;

  /// anchor position of popup widget
  final Alignment popupAnchor;

  /// offset of the popup
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

  const BadPopup.dropdown({
    super.key,
    required this.controller,
    required this.child,
    required this.popup,
    this.offset = Offset.zero,
  })  : targetAnchor = Alignment.bottomCenter,
        popupAnchor = Alignment.topCenter;

  @override
  State<BadPopup> createState() => _BadPopupState();
}

class _BadPopupState extends State<BadPopup> {
  final LayerLink _link = LayerLink();

  late final OverlayEntry entry;

  @override
  void initState() {
    super.initState();

    entry = OverlayEntry(
      // NOTE: not elegant, but it works
      builder: (context) => Positioned(
        top: 0,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: widget.offset,
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.popupAnchor,
          child: widget.popup,
        ),
      ),
    );

    widget.controller._entry = entry;
    widget.controller._show = () => Overlay.of(context).insert(entry);
  }

  @override
  void dispose() {
    widget.controller._entry = null;
    widget.controller._show = null;
    if (entry.mounted) entry.remove();
    entry.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _link, child: widget.child);
  }
}
