import 'package:example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BootPage extends StatelessWidget {
  const BootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boot'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => Get.toNamed(NamedRoute.request),
            child: Text('request_impl'),
          ),
        ],
      ),
    );
  }
}
