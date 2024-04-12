import 'package:example/pages/boot.dart';
import 'package:example/pages/request.dart';
import 'package:example/routes/name.dart';
import 'package:get/get.dart';

final List<GetPage> route = [
  GetPage(name: NamedRoute.boot, page: () => const BootPage()),
  GetPage(name: NamedRoute.request, page: () => const RequestPage()),
];
