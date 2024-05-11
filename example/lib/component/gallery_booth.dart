import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl/prefab/button.dart';
import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/wrapper/clickable.dart';
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
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: _gery),
        borderRadius: BorderRadius.circular(8),
        boxShadow: _hover ? _shadow : null,
      ),
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
          onPressed: () {},
        ),
        BadButton(
          width: 100,
          height: 32,
          borderRadius: 4,
          border: Border.all(color: Colors.green, width: 2),
          child: const BadText('Button', color: Colors.green),
          onPressed: () {},
        ),
        BadButton(
          width: 100,
          height: 32,
          border: const Border(
            top: BorderSide(color: Colors.orange, width: 2),
            bottom: BorderSide(color: Colors.orange, width: 2),
          ),
          child: const BadText('Button', color: Colors.orange),
          onPressed: () {},
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
        BadCheckBox.icon(
          size: 32,
          checkedColor: Colors.blue,
          icon: const Icon(Icons.check, size: 24, color: Colors.white),
          checked: true,
          onTap: () {},
        ),
        BadCheckBox.icon(
          size: 32,
          icon: const Icon(Icons.close, size: 24, color: Colors.green),
          border: Border.all(color: Colors.green, width: 2),
          checked: true,
          onTap: () {},
        ),
        BadCheckBox.icon(
          size: 32,
          icon: const Icon(Icons.accessibility, size: 24, color: Colors.white),
          rounded: false,
          checkedColor: Colors.orange,
          checked: true,
          onTap: () {},
        ),
      ],
    ),
  );
}
