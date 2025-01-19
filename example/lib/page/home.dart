import 'package:example/route/route.dart';
import 'package:flutter/material.dart';
import 'package:bad_fl/bad_fl.dart';

// ===== =====

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(width: 100, color: Colors.red, child: Text('tab1')),
          Container(width: 100, color: Colors.green, child: Text('tab1')),
          Container(width: 100, color: Colors.orange, child: Text('tab1')),
          Container(width: 100, color: Colors.red, child: Text('tab1')),
          Container(width: 100, color: Colors.green, child: Text('tab1')),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController tc;

  @override
  void initState() {
    super.initState();

    tc = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BadFL'),
        bottom: const CustomTabBar(),
      ),
      // body: TabBarView(children: [])
    );
  }
}
