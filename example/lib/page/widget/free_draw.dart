import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class FreeDrawPage extends StatefulWidget {
  const FreeDrawPage({super.key});

  @override
  State<FreeDrawPage> createState() => _FreeDrawState();
}

class _FreeDrawState extends State<FreeDrawPage> {
  final FreeDrawController fdc = FreeDrawController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreeDraw'),
        actions: [
          IconButton(
            onPressed: fdc.undoAll,
            icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
          ),
          IconButton(
            onPressed: fdc.undo,
            icon: const Icon(Icons.keyboard_arrow_left_rounded),
          ),
          IconButton(
            onPressed: fdc.redo,
            icon: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
          IconButton(
            onPressed: fdc.redoAll,
            icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
          ),
        ],
      ),
      body: BadFreeDraw(controller: fdc),
    );
  }
}
