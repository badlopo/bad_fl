import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/layout/expandable.dart';
import 'package:example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SamplePage extends StatelessWidget {
  final String title;
  final String description;

  const SamplePage({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BadText(title, fontWeight: FontWeight.w500),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        tooltip: 'Home',
        onPressed: () => Get.offAllNamed(NamedRoute.boot),
        child: const Icon(Icons.home_outlined, color: Colors.grey),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: BadExpandable(
              title: const BadText('Description', fontWeight: FontWeight.w500),
              child: BadText(description, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: BadExpandable(
              // TODO
              title: BadText('Section Name'),
              child: BadText('This is a sample page.'),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: BadExpandable(
              // TODO
              title: BadText('Section Name'),
              child: BadText('This is a sample page.'),
            ),
          ),
        ],
      ),
    );
  }
}
