import 'package:flutter/material.dart';

class NumPage extends StatefulWidget {
  const NumPage({super.key});

  @override
  State<NumPage> createState() => _NumState();
}

class _NumState extends State<NumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ext::Num')),
      body: ListView(
        children: [
          Text('xxx'),
        ],
      ),
    );
  }
}
