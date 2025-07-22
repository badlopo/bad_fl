import 'package:example/misc/lifecycle_report.dart';
import 'package:flutter/material.dart';
import 'package:bad_fl/bad_fl.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({super.key});

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  int active = 1;

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final int no in [1, 2, 3])
              ElevatedButton(
                onPressed: () {
                  // nsc.setLayer('page$no');
                  setState(() {
                    active = no;
                  });
                },
                child: Text('to page$no'),
              ),
          ],
        ),
      ),
    );
  }
}
