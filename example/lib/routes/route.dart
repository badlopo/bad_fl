import 'package:bad_fl_example/page/gallery.dart';
import 'package:bad_fl_example/page/prefab/button.dart';
import 'package:bad_fl_example/page/prefab/checkbox.dart';
import 'package:bad_fl_example/routes/name.dart';
import 'package:get/get.dart';

final List<GetPage> route = [
  GetPage(name: NamedRoute.gallery, page: () => const GalleryView()),
  GetPage(name: NamedRoute.button, page: () => const ButtonView()),
  GetPage(name: NamedRoute.checkbox, page: () => const CheckBoxView()),
];
