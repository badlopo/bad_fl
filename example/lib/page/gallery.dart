import 'package:bad_fl/bad_fl.dart';
import 'package:example/route.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('BadFL Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BadPanel(
            title: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: BadText('Prefab'),
            ),
            items: [
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabBackToTop),
                label: const BadText('BackToTop'),
              ),
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabButton),
                label: const BadText('Button'),
              ),
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabCarousel),
                label: const BadText('Carousel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
