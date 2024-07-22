import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

class BadRefreshable extends StatelessWidget {
  final FutureOr<void> Function()? onRefresh;
  final FutureOr<void> Function()? onLoadMore;
  final Widget child;

  const BadRefreshable({
    super.key,
    this.onRefresh,
    this.onLoadMore,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: const MaterialHeader(triggerOffset: 60),
      footer: const MaterialFooter(triggerOffset: 60),
      onRefresh: onRefresh,
      onLoad: onLoadMore,
      child: child,
    );
  }
}
