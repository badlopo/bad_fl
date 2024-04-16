import 'package:example/pages/boot.dart';
import 'package:example/pages/helper/debounce.dart';
import 'package:example/routes/name.dart';
import 'package:get/get.dart';

final List<GetPage> route = [
  GetPage(name: NamedRoute.boot, page: () => const BootPage()),

  // helper
  GetPage(name: NamedRoute.debounce, page: () => const DebouncePage()),

  // tobe implemented
];
