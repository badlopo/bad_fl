import 'package:example/route.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(const MyApp());
  runWidget(const SimpleApp());
}

class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'SimpleApp', home: SimpleAppView());
  }
}

class SimpleAppView extends StatelessWidget {
  const SimpleAppView({super.key});

  @override
  Widget build(BuildContext context) {
    print('SimpleAppView.build');
    return Scaffold(
      appBar: AppBar(title: const Text('SimpleAppView')),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BadFL Gallery',
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F8F0),
      ),
      routes: NamedRoute.routes,
    );
  }
}
