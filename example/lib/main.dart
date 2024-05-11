import 'package:bad_fl_example/page/unknown.dart';
import 'package:bad_fl_example/routes/name.dart';
import 'package:bad_fl_example/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _mobile = true;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bad FL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'JetBrainsMono',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: NamedRoute.gallery,
      unknownRoute: GetPage(name: '/unknown', page: () => const UnknownPage()),
      getPages: route,
      transitionDuration: Duration.zero,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.lightGreen,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _mobile = !_mobile;
              });
            },
            child: Icon(_mobile ? Icons.computer : Icons.phone_android),
          ).marginOnly(top: 16),
          body: _mobile
              ? Center(
                  child: Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: 390,
                      height: 844,
                      child: child!,
                    ),
                  ),
                )
              : child,
        );
      },
    );
  }
}
