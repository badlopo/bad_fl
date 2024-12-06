import 'package:flutter/material.dart';

class IterablePage extends StatefulWidget {
  const IterablePage({super.key});

  @override
  State<IterablePage> createState() => _IterableState();
}

class _IterableState extends State<IterablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ext::Iterable'),
      ),
    );
  }
}
