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
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabCheckbox),
                label: const BadText('Checkbox'),
              ),
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabClickable),
                label: const BadText('Clickable'),
              ),
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabExpandable),
                label: const BadText('Expandable'),
              ),
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabFloating),
                label: const BadText('Floating'),
              ),
              BadPanelItem(
                onTap: () =>
                    Navigator.pushNamed(context, NamedRoute.prefabKatex),
                label: const BadText('Katex'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
