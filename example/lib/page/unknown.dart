import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl_example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BadText(
              '404',
              fontSize: 32,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(NamedRoute.gallery),
              child: const BadText('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
