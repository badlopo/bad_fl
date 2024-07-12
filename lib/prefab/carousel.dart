import 'package:flutter/material.dart';

typedef IndicatorBuilder = Widget Function(BuildContext context, int index);

class BadCarousel extends StatefulWidget {
  /// called whenever the page in the center of the viewport changes
  final ValueChanged<int>? onPageChanged;

  /// called when the user swipes out the last page
  final VoidCallback? onSwipeOut;

  /// builder for the indicator widget
  ///
  /// you can return a [Positioned] widget to place the indicator
  final IndicatorBuilder? indicatorBuilder;

  /// children to display in the carousel
  final List<Widget> children;

  const BadCarousel({
    super.key,
    this.onPageChanged,
    this.onSwipeOut,
    this.indicatorBuilder,
    required this.children,
  });

  @override
  State<BadCarousel> createState() => _BadCarouselState();
}

class _BadCarouselState extends State<BadCarousel> {
  late final int pageCount;
  final PageController controller = PageController();

  int _lastIndex = 0;
  late final ValueNotifier? _notifier;

  void _pageChangeDelegate(int index) {
    if (index == pageCount) {
      controller.jumpToPage(pageCount - 1);
      widget.onSwipeOut?.call();
      return;
    }

    if (_lastIndex != index) {
      _lastIndex = index;
      _notifier?.value = index;
      widget.onPageChanged?.call(index);
    }
  }

  @override
  void initState() {
    super.initState();

    pageCount = widget.children.length;
    _notifier = widget.indicatorBuilder == null ? null : ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    Widget pages = PageView.builder(
      controller: controller,
      onPageChanged: _pageChangeDelegate,
      itemCount: pageCount + 1,
      itemBuilder: (_, index) {
        if (index == pageCount) return const SizedBox.shrink();
        return widget.children[index];
      },
    );

    if (widget.indicatorBuilder != null) {
      pages = Stack(
        children: [
          pages,
          ValueListenableBuilder(
            valueListenable: _notifier!,
            builder: (context, index, _) {
              return widget.indicatorBuilder!(context, index);
            },
          ),
        ],
      );
    }

    return pages;
  }
}

class BadCarouselCyclic extends StatefulWidget {
  /// called whenever the page in the center of the viewport changes
  final ValueChanged<int>? onPageChanged;

  /// builder for the indicator widget
  ///
  /// you can return a [Positioned] widget to place the indicator
  final IndicatorBuilder? indicatorBuilder;

  /// children to display in the carousel
  final List<Widget> children;

  const BadCarouselCyclic({
    super.key,
    this.onPageChanged,
    this.indicatorBuilder,
    required this.children,
  });

  @override
  State<BadCarouselCyclic> createState() => _BadCarouselCyclicState();
}

class _BadCarouselCyclicState extends State<BadCarouselCyclic> {
  late final int pageCount;

  late final ValueNotifier? _notifier;

  void _pageChangeDelegate(int index) {
    index %= pageCount;
    _notifier?.value = index;
    widget.onPageChanged?.call(index);
  }

  @override
  void initState() {
    super.initState();

    pageCount = widget.children.length;
    _notifier = widget.indicatorBuilder == null ? null : ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    Widget pages = PageView.builder(
      // FIXME: here we use a large number to make the carousel cyclic, this is a hack
      controller: PageController(initialPage: pageCount * 100),
      onPageChanged: _pageChangeDelegate,
      itemBuilder: (_, index) => widget.children[index % pageCount],
    );

    if (widget.indicatorBuilder != null) {
      pages = Stack(
        children: [
          pages,
          ValueListenableBuilder(
            valueListenable: _notifier!,
            builder: (context, index, _) {
              return widget.indicatorBuilder!(context, index);
            },
          ),
        ],
      );
    }

    return pages;
  }
}
