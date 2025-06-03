import 'package:flutter/material.dart';

class LifecycleReportPage extends StatefulWidget {
  final String name;

  const LifecycleReportPage({super.key, required this.name});

  @override
  State<LifecycleReportPage> createState() => _LifecycleReportPageState();
}

class _LifecycleReportPageState extends State<LifecycleReportPage> {
  @override
  void initState() {
    super.initState();

    print('[${widget.name}] initState');
  }

  @override
  void didUpdateWidget(covariant LifecycleReportPage oldWidget) {
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
    return Scaffold(
      body: Text(widget.name),
    );
  }
}
