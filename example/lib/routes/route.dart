import 'package:example/pages/boot.dart';
import 'package:example/pages/prefab/checkbox.dart';
import 'package:example/pages/prefab/text.dart';
import 'package:example/pages/request.dart';
import 'package:example/routes/name.dart';
import 'package:get/get.dart';

final List<GetPage> route = [
  GetPage(name: NamedRoute.boot, page: () => const BootPage()),

  // prefab
  GetPage(name: NamedRoute.checkbox, page: () => const BadCheckBoxDocPage()),
  GetPage(name: NamedRoute.text, page: () => const BadTextDocPage()),

  // impl
  GetPage(name: NamedRoute.request, page: () => const RequestPage()),
];
