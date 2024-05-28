import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl_example/component/gallery_booth.dart';
import 'package:flutter/material.dart';

const _linkPub = 'https://pub.dev/packages/bad_fl';
const _linkGitHub = 'https://github.com/badlopo/bad_fl';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BadText('Bad FL', fontWeight: FontWeight.w700),
        actions: [
          IconButton(
            tooltip: 'View on Pub.dev',
            onPressed: () => ExternalLinkImpl.openExternal(_linkPub),
            icon: Image.asset('dart.png', width: 24, height: 24),
          ),
          IconButton(
            tooltip: 'View on GitHub',
            onPressed: () => ExternalLinkImpl.openExternal(_linkGitHub),
            icon: Image.asset('github.png', width: 24, height: 24),
          ),
        ],
      ),
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
