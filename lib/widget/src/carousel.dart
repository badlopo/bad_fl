import 'package:flutter/material.dart';

typedef IndicatorBuilder = Widget Function(BuildContext context, int index);

sealed class BadCarousel extends StatefulWidget {
  final List<Widget> pages;

  /// Build the indicator widget according to the current page index.
  ///
  /// Since we wrap the indicator widget in [Stack],
  /// you can return a [Positioned] widget to place the indicator.
  final IndicatorBuilder? indicatorBuilder;

  final ValueChanged<int>? onPageChanged;

  const BadCarousel({
    super.key,
    this.onPageChanged,
    this.indicatorBuilder,
    required this.pages,
  }) : assert(pages.length != 0, 'Think twice!');
}

/// Carousel with limited pages, when the user swipes out the last page, [onSwipeOut] will be called.
class BadLinearCarousel extends BadCarousel {
  final VoidCallback? onSwipeOut;

  const BadLinearCarousel({
    super.key,
    super.onPageChanged,
    this.onSwipeOut,
    super.indicatorBuilder,
    required super.pages,
  });

  @override
  State<BadLinearCarousel> createState() => _LinearCarouselState();
}

class _LinearCarouselState extends State<BadLinearCarousel> {
  final PageController controller = PageController();

  int get _count => widget.pages.length;

  /// cache the last index to avoid duplicate calls to onPageChanged and notifier
  int _lastIndex = 0;

  // non-null when indicatorBuilder is set
  late final ValueNotifier? _notifier;

  void _handlePageChanged(int to) {
    // if the target is the trailing phantom page,
    // automatically jump back to previous page and call `onSwipeOut`
    if (to == _count) {
      controller.jumpToPage(_count - 1);
      widget.onSwipeOut?.call();
      return;
    }

    // filter out duplicate calls
    if (_lastIndex == to) return;

    _lastIndex = to;
    _notifier?.value = to;
    widget.onPageChanged?.call(to);
  }

  @override
  void initState() {
    super.initState();

    _notifier = widget.indicatorBuilder == null ? null : ValueNotifier(0);
  }

  @override
  void dispose() {
    _notifier?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = PageView.builder(
      controller: controller,
      onPageChanged: _handlePageChanged,
      itemCount: _count + 1,
      itemBuilder: (_, index) {
        // trailing phantom page
        if (index == _count) return const SizedBox.shrink();

        // normal pages
        return widget.pages[index];
      },
    );

    // if indicatorBuilder is null, return the child directly
    if (widget.indicatorBuilder == null) return child;

    // otherwise, wrap the child with `Stack` and add the indicator widget
    return Stack(
      children: [
        child,
        ValueListenableBuilder(
          valueListenable: _notifier!,
          builder: (context, index, _) {
            return widget.indicatorBuilder!(context, index);
          },
        ),
      ],
    );
  }
}

/// Carousel with cyclic behavior, when the user swipes out the last page, it will jump back to the first page as if it's infinite.
class BadCyclicCarousel extends BadCarousel {
  const BadCyclicCarousel({
    super.key,
    super.onPageChanged,
    super.indicatorBuilder,
    required super.pages,
  });

  @override
  State<BadCyclicCarousel> createState() => _CyclicCarouselState();
}

class _CyclicCarouselState extends State<BadCyclicCarousel> {
  final PageController controller = PageController(initialPage: 1);

  int get _count => widget.pages.length;

  /// cache the last index to avoid duplicate calls to onPageChanged and notifier
  int _lastIndex = 0;

  // non-null when indicatorBuilder is set
  late final ValueNotifier? _notifier;

  void _handlePageChanged(int to) {
    int facadeIndex = to - 1;
    if (to == 0) {
      facadeIndex = _count - 1;
    } else if (to == _count + 1) {
      facadeIndex = 0;
    }

    if (_lastIndex == facadeIndex) return;

    _lastIndex = facadeIndex;
    _notifier?.value = facadeIndex;
    widget.onPageChanged?.call(facadeIndex);
  }

  void _cyclicImpl() {
    // when the page changed to the leading phantom page,
    // replace the page index with the index of corresponding page
    if (controller.page == 0.0) {
      controller.jumpToPage(_count);
    }

    // same for the trailing phantom page
    else if (controller.page == _count + 1.0) {
      controller.jumpToPage(1);
    }
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(_cyclicImpl);
    _notifier = widget.indicatorBuilder == null ? null : ValueNotifier(0);
  }

  @override
  void dispose() {
    _notifier?.dispose();
    controller.removeListener(_cyclicImpl);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // queue: [ leading phantom 1, ...pages, trailing phantom 1]

    final child = PageView.builder(
      controller: controller,
      onPageChanged: _handlePageChanged,
      itemCount: _count + 2,
      itemBuilder: (_, index) {
        int pageNo = index - 1;
        if (index == 0) {
          pageNo = _count - 1;
        } else if (index == _count + 1) {
          pageNo = 0;
        }

        return widget.pages[pageNo];
      },
    );

    // if indicatorBuilder is null, return the child directly
    if (widget.indicatorBuilder == null) return child;

    // otherwise, wrap the child with `Stack` and add the indicator widget
    return Stack(
      children: [
        child,
        ValueListenableBuilder(
          valueListenable: _notifier!,
          builder: (context, index, _) {
            return widget.indicatorBuilder!(context, index);
          },
        ),
      ],
    );
  }
}
