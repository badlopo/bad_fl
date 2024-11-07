import 'package:example/multi_view_wrapper.dart';
import 'package:example/page/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  // runWidget(MultiViewWrapper(appBuilder: (_, initialData) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BadFL',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F8F0),
      ),
      home: const HomePage(),
    );
  }
}
