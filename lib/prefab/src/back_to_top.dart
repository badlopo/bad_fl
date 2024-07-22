import 'package:bad_fl/core.dart';
import 'package:flutter/material.dart';

import 'clickable.dart';

class BadBackToTop extends StatefulWidget {
  /// the scroll controller to listen to
  final ScrollController scrollController;

  /// the threshold to show the back to top button, when set to 0, the button will always be visible
  ///
  /// Default to `100`
  final double threshold;

  /// the child widget.
  final Widget child;

  /// the duration of the scroll animation
  final Duration? duration;

  /// the curve of the scroll animation
  final Curve? curve;

  /// by default, [BadBackToTop] will jump to the top when clicked
  const BadBackToTop({
    super.key,
    required this.scrollController,
    this.threshold = 100,
    this.child = const Icon(Icons.arrow_upward, size: 24),
  })  : assert(threshold >= 0, 'threshold must be greater than or equal to 0'),
        duration = null,
        curve = null;

  /// animate the scroll to the top when clicked
  const BadBackToTop.animated({
    super.key,
    required this.scrollController,
    this.threshold = 100,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.child = const Icon(Icons.arrow_upward, size: 24),
  })  : assert(threshold >= 0, 'threshold must be greater than or equal to 0'),
        assert(duration != null, 'duration must not be null'),
        assert(curve != null, 'curve must not be null');

  @override
  State<BadBackToTop> createState() => _BadBackToTopState();
}

class _BadBackToTopState extends State<BadBackToTop> {
  bool visible = false;
  late final void Function() handleClick;

  void _listener() {
    if (widget.scrollController.offset >= widget.threshold) {
      if (!visible) {
        setState(() => visible = true);
        BadFl.log(
          module: 'BadBackToTop',
          message: 'visibility changed to "true"',
        );
      }
    } else {
      if (visible) {
        setState(() => visible = false);
        BadFl.log(
          module: 'BadBackToTop',
          message: 'visibility changed to "false"',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // set the handleClick function
    if (widget.duration != null) {
      handleClick = () {
        widget.scrollController.animateTo(
          0,
          duration: widget.duration!,
          curve: widget.curve!,
        );
      };
    } else {
      handleClick = () => widget.scrollController.jumpTo(0);
    }

    if (widget.threshold != 0) {
      // add the listener
      widget.scrollController.addListener(_listener);
    } else {
      // always visible
      visible = true;
    }
  }

  @override
  void dispose() {
    // remove the listener
    if (widget.threshold != 0) {
      widget.scrollController.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return BadClickable(onClick: handleClick, child: widget.child);
  }
}
