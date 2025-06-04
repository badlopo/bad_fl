import 'package:flutter/material.dart';

enum ShimmerDirection { l2r, r2l, t2b, b2t }

extension on ShimmerDirection {
  Axis get axis => switch (this) {
        ShimmerDirection.l2r || ShimmerDirection.r2l => Axis.horizontal,
        ShimmerDirection.t2b || ShimmerDirection.b2t => Axis.vertical,
      };
}

extension on Axis {
  AlignmentGeometry get gradientBegin => switch (this) {
        Axis.horizontal => Alignment.centerLeft,
        Axis.vertical => Alignment.topCenter,
      };

  AlignmentGeometry get gradientEnd => switch (this) {
        Axis.horizontal => Alignment.centerRight,
        Axis.vertical => Alignment.bottomCenter,
      };
}

/// Simple shimmer brick widget.
class BadShimmer extends StatefulWidget {
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final Border? border;
  final double borderRadius;
  final Color fill;

  final Duration duration;
  final ShimmerDirection direction;

  // final double rotateAngle;

  /// Times to repeat. Set to `0` to make it infinite.
  final int repeat;

  /// Time to delay before next repeat.
  final Duration repeatDelay;

  const BadShimmer({
    super.key,
    this.width,
    required this.height,
    this.margin,
    this.border,
    this.borderRadius = 0,
    this.fill = Colors.grey,
    this.duration = const Duration(seconds: 1),
    this.direction = ShimmerDirection.l2r,
    // this.rotateAngle = 0,
    this.repeat = 0,
    this.repeatDelay = Duration.zero,
  }) : assert(repeat >= 0, 'out of range');

  @override
  State<StatefulWidget> createState() => _ShimmerState();
}

class _ShimmerState extends State<BadShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  int _count = 0;

  void _flush() {
    setState(() {});
  }

  void _onStatusChanged(AnimationStatus status) async {
    if (status != AnimationStatus.completed) return;

    if (widget.repeat == 0 || _count < widget.repeat) {
      if (widget.repeatDelay != Duration.zero) {
        await Future.delayed(widget.repeatDelay);
      }
      _count += 1;
      _controller.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addListener(_flush);
    _controller.addStatusListener(_onStatusChanged);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BadShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.removeListener(_flush);
    _controller.removeStatusListener(_onStatusChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.borderRadius == 0
            ? null
            : BorderRadius.circular(widget.borderRadius),
        color: widget.fill,
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final axis = widget.direction.axis;

          Widget shimmer = UnconstrainedBox(
            child: Container(
              width: axis == Axis.horizontal ? w / 2 : w,
              height: axis == Axis.horizontal ? h : h / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: axis.gradientBegin,
                  end: axis.gradientEnd,
                ),
              ),
            ),
          );

          // create transform instance
          final transform = Matrix4.identity();

          // apply translate
          switch (widget.direction) {
            case ShimmerDirection.l2r:
              transform.translate(1.5 * w * _controller.value - 0.75 * w);
              break;
            case ShimmerDirection.r2l:
              transform.translate(0.75 * w - 1.5 * w * _controller.value);
              break;
            case ShimmerDirection.t2b:
              transform.translate(0.0, 1.5 * h * _controller.value - 0.75 * h);
              break;
            case ShimmerDirection.b2t:
              transform.translate(0.0, 0.75 * h - 1.5 * h * _controller.value);
              break;
          }

          // OPTIMIZE: apply rotation
          // if (widget.rotateAngle != 0) transform.rotateZ(widget.rotateAngle);

          return Transform(transform: transform, child: shimmer);
        },
      ),
    );
  }
}
