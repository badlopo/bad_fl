import 'package:example/misc/lifecycle_report.dart';
import 'package:example/route/route.dart';
import 'package:flutter/material.dart';
import 'package:bad_fl/bad_fl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final name in [
            RouteNames.home,
            RouteNames.draft,
            RouteNames.button,
          ])
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(name);
              },
              child: Text('to $name'),
            ),
        ].separateToList(
          convert: asIs,
          separator: const SizedBox(height: 16),
        ),
      ),
    );
  }
}
