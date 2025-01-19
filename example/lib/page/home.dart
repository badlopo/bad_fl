import 'package:example/page/widget/free_draw.dart';
import 'package:example/page/widget/tree.dart';
import 'package:flutter/material.dart';
import 'package:bad_fl/bad_fl.dart';

class TabItem extends StatelessWidget {
  final bool active;
  final String label;
  final VoidCallback onClick;

  const TabItem({
    super.key,
    required this.active,
    required this.label,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                label,
                style: active
                    ? const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )
                    : const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
              ),
            ),
          ),
          active
              ? Container(
                  width: 24,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.blue,
                  ),
                )
              : const SizedBox(height: 4),
        ],
      ),
    );

    return BadClickable(onClick: onClick, child: inner);
  }
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final int activeIndex;
  final ValueChanged<int> onChanged;

  const CustomTabBar({
    super.key,
    required this.activeIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        children: [
          TabItem(
            active: activeIndex == 0,
            label: 'Free draw',
            onClick: () => onChanged(0),
          ),
          TabItem(
            active: activeIndex == 1,
            label: 'Tree',
            onClick: () => onChanged(1),
          ),
          // TODO: more tabs here
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

class _HomePageState extends State<HomePage> {
  int active = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BadFL ShowCases'),
        bottom: CustomTabBar(
          activeIndex: active,
          onChanged: (to) {
            setState(() {
              active = to;
            });
          },
        ),
        shape:
            Border(bottom: BorderSide(color: Colors.grey.shade300, width: 4)),
      ),
      body: IndexedStack(
        index: active,
        children: const [
          FreeDrawPage(),
          TreePage(),
        ],
      ),
    );
  }
}
