import 'package:bad_fl/bad_fl.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class PrefabClickableView extends StatelessWidget {
  const PrefabClickableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Clickable Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const BadText('Clickable on Text'),
          BadClickable(
            onClick: () => Utils.showSnackBar(context, 'text clicked!'),
            child: const BadText('click on me', color: Colors.grey),
          ),
          const BadText('Clickable on Image'),
          BadClickable(
            onClick: () => Utils.showSnackBar(context, 'image clicked!'),
            child: Image.network(
              'https://picsum.photos/200',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
