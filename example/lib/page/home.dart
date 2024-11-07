import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print(WidgetsBinding.instance.platformDispatcher.views.length);
          },
          child: const Text('get num of view!'),
        ),
      ),
    );
  }
}
