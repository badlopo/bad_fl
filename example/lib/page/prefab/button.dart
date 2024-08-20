import 'package:bad_fl/bad_fl.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class PrefabButtonView extends StatelessWidget {
  const PrefabButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Button Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          BadButton(
            height: 48,
            borderRadius: 8,
            border: Border.all(),
            child: const BadText('Button1'),
            onPressed: () => Utils.showSnackBar(context, 'Button1 pressed'),
          ),
          BadButton(
            height: 48,
            borderRadius: 8,
            fill: Colors.blue,
            child: const BadText('Button2', color: Colors.white),
            onPressed: () => Utils.showSnackBar(context, 'Button2 pressed'),
          ),
          BadButton(
            height: 48,
            border: const Border.symmetric(horizontal: BorderSide()),
            child: const BadText('Button3'),
            onPressed: () => Utils.showSnackBar(context, 'Button3 pressed'),
          ),
          BadButton(
            height: 48,
            border: const Border(
              top: BorderSide(color: Colors.red),
              right: BorderSide(color: Colors.green),
              bottom: BorderSide(color: Colors.blue),
              left: BorderSide(color: Colors.orange),
            ),
            child: const BadText('Button4'),
            onPressed: () => Utils.showSnackBar(context, 'Button4 pressed'),
          ),
        ].slotted(slot: const SizedBox(height: 16)),
      ),
    );
  }
}
