import 'package:example/page/gallery.dart';
import 'package:example/page/prefab/back_to_top.dart';
import 'package:example/page/prefab/button.dart';
import 'package:example/page/prefab/carousel.dart';
import 'package:example/page/prefab/checkbox.dart';
import 'package:example/page/prefab/clickable.dart';
import 'package:example/page/prefab/expandable.dart';
import 'package:example/page/prefab/floating.dart';
import 'package:example/page/prefab/katex.dart';

abstract class NamedRoute {
  static const String gallery = '/';
  static const String prefabBackToTop = '/prefab/back_to_top';
  static const String prefabButton = '/prefab/button';
  static const String prefabCarousel = '/prefab/carousel';
  static const String prefabCheckbox = '/prefab/checkbox';
  static const String prefabClickable = '/prefab/clickable';
  static const String prefabExpandable = '/prefab/expandable';
  static const String prefabFloating = '/prefab/floating';
  static const String prefabKatex = '/prefab/katex';

  static final routes = {
    gallery: (context) => const GalleryView(),
    prefabBackToTop: (context) => const PrefabBackToTopView(),
    prefabButton: (context) => const PrefabButtonView(),
    prefabCarousel: (context) => const PrefabCarouselView(),
    prefabCheckbox: (context) => const PrefabCheckboxView(),
    prefabClickable: (context) => const PrefabClickableView(),
    prefabExpandable: (context) => const PrefabExpandableView(),
    prefabFloating: (context) => const PrefabFloatingView(),
    prefabKatex: (context) => const PrefabKatexView(),
  };
}
