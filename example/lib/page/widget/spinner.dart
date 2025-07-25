import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class SpinnerPage extends StatelessWidget {
  const SpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Wrap(
          children: [
            BadSpinner(child: Icon(Icons.refresh)),
            BadSpinner(child: Icon(Icons.ac_unit, size: 16)),
            BadSpinner(child: Icon(Icons.abc, size: 32)),
            BadSpinner(child: Icon(Icons.query_stats, size: 48)),
            BadSpinner(reverse: true, child: Icon(Icons.refresh)),
            BadSpinner(reverse: true, child: Icon(Icons.account_tree)),
            BadSpinner(
              duration: Duration(seconds: 4),
              child: BadText('Hello'),
            ),
            BadSpinner(
              duration: Duration(seconds: 2),
              child: BadText('BadFL', fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
