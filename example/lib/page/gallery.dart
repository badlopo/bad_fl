import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl_example/component/gallery_booth.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Bad FL')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GalleryItem.button,
          GalleryItem.checkbox,
        ].slotted(builder: (v) => v, slot: const SizedBox(height: 16)),
      ),
    );
  }
}
