import 'package:bad_fl/prefab/button.dart';
import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl_example/component/gallery_booth.dart';
import 'package:bad_fl_example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const forwardIcon = Icon(Icons.arrow_right, size: 16);

class BootPage extends StatelessWidget {
  const BootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Bad FL')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GalleryItem.button,
          Align(
            alignment: Alignment.centerLeft,
            child: Hero(
              tag: 'test',
              child: Container(
                width: 20,
                height: 100,
                color: Colors.orange,
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (e) {
              print('hover');
            },
            child: BadButton(
              height: 32,
              onPressed: () => Get.toNamed(NamedRoute.misc),
              child: const BadText('to /misc'),
            ),
          ),
        ],
      ),
    );
  }
}
