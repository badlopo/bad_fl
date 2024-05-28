import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl_example/component/gallery_booth.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Bad FL')),
      backgroundColor: const Color(0xFFF7FBF1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            // use a SizedBox with enough width to make the Wrap expand to the full width
            const SizedBox(width: double.infinity),
            GalleryItem.button,
            GalleryItem.checkbox,
            GalleryItem.katex,
          ],
        ),
      ),
    );
  }
}
