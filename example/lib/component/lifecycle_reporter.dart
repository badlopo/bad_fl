import 'package:flutter/material.dart';

class LifecycleReporter extends StatefulWidget {
  final String name;

  const LifecycleReporter({super.key, required this.name});

  @override
  State<LifecycleReporter> createState() => _LifecycleReporterState();
}

class _LifecycleReporterState extends State<LifecycleReporter> {
  @override
  void initState() {
    super.initState();

    print('[${widget.name}] initState');
  }

  @override
  void didUpdateWidget(covariant LifecycleReporter oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('[${widget.name}] didUpdateWidget');
  }

  @override
  void dispose() {
    print('[${widget.name}] dispose');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.name);
  }
}
