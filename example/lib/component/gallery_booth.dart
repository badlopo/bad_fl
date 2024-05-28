// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl_example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _gery = Color(0xFFF0F0F0);
const _shadow = [
  BoxShadow(
    color: Color(0x14000000),
    offset: Offset(0, 6),
    blurRadius: 16,
    spreadRadius: -8,
  ),
  BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0, 9),
    blurRadius: 28,
  ),
  BoxShadow(
    color: Color(0x08000000),
    offset: Offset(0, 12),
    blurRadius: 48,
    spreadRadius: 16,
  ),
];

class GalleryBooth extends StatefulWidget {
  final String name;
  final String route;
  final Widget child;

  const GalleryBooth({
    super.key,
    required this.name,
    required this.route,
    required this.child,
  });

  @override
  State<GalleryBooth> createState() => _GalleryBoothState();
}

class _GalleryBoothState extends State<GalleryBooth> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final inner = AnimatedContainer(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: _gery),
        borderRadius: BorderRadius.circular(8),
        boxShadow: _hover ? _shadow : null,
      ),
      width: 390,
      height: 200,
      child: Column(
        children: [
          SizedBox(
            height: 38,
            child: BadText(
              widget.name,
              fontSize: 18,
              lineHeight: 38,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _gery),
          Expanded(child: widget.child),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: BadClickable(
        onClick: () => Get.toNamed(widget.route),
        child: inner,
      ),
    );
  }
}

void showAlert(String message) {
  js.context.callMethod('alert', [message]);
}

abstract class GalleryItem {
  static final button = GalleryBooth(
    name: 'BadButton',
    route: NamedRoute.button,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BadButton(
          width: 100,
          height: 32,
          borderRadius: 4,
          fill: Colors.blue,
          child: const BadText('Button', color: Colors.white),
          onPressed: () => showAlert('Button pressed'),
        ),
        BadButton(
          width: 100,
          height: 32,
          borderRadius: 4,
          border: Border.all(color: Colors.green, width: 2),
          child: const BadText('Button', color: Colors.green),
          onPressed: () => showAlert('Button pressed'),
        ),
        BadButton(
          width: 100,
          height: 32,
          border: const Border(
            top: BorderSide(color: Colors.orange, width: 2),
            bottom: BorderSide(color: Colors.orange, width: 2),
          ),
          child: const BadText('Button', color: Colors.orange),
          onPressed: () => showAlert('Button pressed'),
        ),
      ],
    ),
  );

  static final checkbox = GalleryBooth(
    name: 'BadCheckbox',
    route: NamedRoute.checkbox,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ObxValue((v) {
          return BadCheckBox.icon(
            size: 32,
            fill: Colors.blue,
            icon: const Icon(Icons.check, size: 24, color: Colors.white),
            checked: v.isTrue,
            onTap: v.toggle,
          );
        }, true.obs),
        ObxValue((v) {
          return BadCheckBox.icon(
            size: 32,
            icon: const Icon(Icons.close, size: 24, color: Colors.green),
            border: Border.all(color: Colors.green, width: 2),
            checked: v.isTrue,
            onTap: v.toggle,
          );
        }, true.obs),
        ObxValue((v) {
          return BadCheckBox.iconBuilder(
            size: 32,
            iconBuilder: (c) => c
                ? const Icon(Icons.surfing, size: 24, color: Colors.white)
                : const Icon(Icons.kitesurfing, size: 24, color: Colors.white),
            rounded: false,
            fill: Colors.orange,
            checked: v.isTrue,
            onTap: v.toggle,
          );
        }, true.obs),
      ],
    ),
  );

  static final katex = GalleryBooth(
    name: 'BadKatex',
    route: NamedRoute.katex,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BadKatex(raw: r'$a \ne 0$'),
        BadKatex(raw: r'$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$'),
        BadKatex(raw: r'$ax^2 + bx + c = 0$'),
      ],
    ),
  );
}
