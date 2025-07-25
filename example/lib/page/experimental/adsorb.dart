import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class _AdsorbShowcase extends StatelessWidget {
  final AdsorbStrategy strategy;
  final EdgeInsets insets;
  final String title;
  final String description;

  const _AdsorbShowcase({
    required this.strategy,
    this.insets = EdgeInsets.zero,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BadText(
          title,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: BadText(description),
        ),
        Stack(
          children: [
            ColoredBox(
              color: Colors.grey.shade300,
              child: const SizedBox(width: 200, height: 200),
            ),
            BadAdsorb(
              strategy: strategy,
              insets: insets,
              parentSize: const Size(200, 200),
              size: const Size(30, 30),
              child: const ColoredBox(color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

class AdsorbPage extends StatelessWidget {
  const AdsorbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        _AdsorbShowcase(
          strategy: AdsorbStrategy.both,
          title: 'Adsorption strategy: both',
          description: '释放后，红色方块将自动吸附到最近的边缘。',
        ),
        Divider(),
        _AdsorbShowcase(
          strategy: AdsorbStrategy.horizontal,
          title: 'Adsorption strategy: horizontal',
          description: '释放后，红色方块将自动吸附到左侧或右侧（较近的一边）。',
        ),
        Divider(),
        _AdsorbShowcase(
          strategy: AdsorbStrategy.vertical,
          title: 'Adsorption strategy: vertical',
          description: '释放后，红色方块将自动吸附到上侧或下侧（较近的一边）。',
        ),
        Divider(),
        _AdsorbShowcase(
          strategy: AdsorbStrategy.none,
          title: 'Adsorption strategy: none',
          description: '释放后，红色方块将保持所在位置。',
        ),
        Divider(),
        _AdsorbShowcase(
          strategy: AdsorbStrategy.both,
          insets: EdgeInsets.all(10),
          title: '正偏移',
          description: '可以通过 insets 参数来设置吸附时的额外偏移，设为正值则向内偏移',
        ),
        Divider(),
        _AdsorbShowcase(
          strategy: AdsorbStrategy.both,
          insets: EdgeInsets.all(-10),
          title: '负偏移',
          description: '可以通过 insets 参数来设置吸附时的额外偏移，设为负值则向外偏移',
        ),
      ],
    );
  }
}
