import 'package:example/routes/name.dart';
import 'package:example/routes/route.dart';
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
        scaffoldBackgroundColor: const Color(0xFFF5F6F7)
      ),
      initialRoute: NamedRoute.boot,
      getPages: route,
    );
  }
}
