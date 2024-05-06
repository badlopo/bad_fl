import 'package:flutter/material.dart';

class BadHeroPreviewer extends StatefulWidget {
  final Widget child;
  final Widget? previewWidget;

  const BadHeroPreviewer({super.key, required this.child, this.previewWidget});

  @override
  State<BadHeroPreviewer> createState() => _BadHeroPreviewerState();
}

class _BadHeroPreviewerState extends State<BadHeroPreviewer> {
  final tag = UniqueKey();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
