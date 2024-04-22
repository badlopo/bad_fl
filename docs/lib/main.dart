import 'package:bad_fl_doc/pages/unknown.dart';
import 'package:bad_fl_doc/routes/name.dart';
import 'package:bad_fl_doc/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bad FL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'JetBrainsMono',
        scaffoldBackgroundColor: const Color(0xFFF5F6F7),
      ),
      initialRoute: NamedRoute.boot,
      unknownRoute: GetPage(name: '/unknown', page: () => const UnknownPage()),
      getPages: route,
      // builder: (context, child) {
      //   return Center(
      //     child: SizedBox(
      //       width: 390,
      //       height: 844,
      //       child: child!,
      //     ),
      //   );
      // },
    );
  }
}