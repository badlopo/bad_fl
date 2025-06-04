import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BadText('Button'),
      ),
      body: ListView(
        children: [
          BadButton(
            onPressed: () async {
              await Future.delayed(Duration(seconds: 2));
            },
            loadingWidget: Text('running ...'),
            child: Text('data'),
          ),
        ],
      ),
    );
  }
}
