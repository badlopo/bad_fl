import 'package:example/page/gallery.dart';
import 'package:example/page/prefab/button.dart';
import 'package:example/page/prefab/carousel.dart';

abstract class NamedRoute {
  static const String gallery = '/';
  static const String prefabButton = '/prefab/button';
  static const String prefabCarousel = '/prefab/carousel';

  static final routes = {
    gallery: (context) => const GalleryView(),
    prefabButton: (context) => const PrefabButtonView(),
    prefabCarousel: (context) => const PrefabCarouselView(),
  };
}
