import 'package:bad_fl/widgets.dart';
import 'package:example/component/html_text.dart';
import 'package:example/layout/page_layout.dart';
import 'package:flutter/material.dart';

class _AdsorbShowcase extends StatelessWidget {
  final AdsorbStrategy strategy;
  final EdgeInsets insets;

  const _AdsorbShowcase({
    required this.strategy,
    this.insets = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

class AdsorbPage extends StatelessWidget {
  const AdsorbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WidgetPageLayout(
      title: 'Adsorb',
      description:
          '为包裹的子组件提供任意拖拽的能力, 可选地进行吸附（水平、竖直、双向）。受限于实现方式，目前该组件需要放置在 Stack 内。',
      children: [
        HtmlText.h2('双向吸附'),
        HtmlText.p('释放后，红色方块将自动吸附到最近的边缘。'),
        _AdsorbShowcase(strategy: AdsorbStrategy.both),
        Divider(),
        HtmlText.h2('水平吸附'),
        HtmlText.p('释放后，红色方块将自动吸附到左侧或右侧（较近的一边）。'),
        _AdsorbShowcase(strategy: AdsorbStrategy.horizontal),
        Divider(),
        HtmlText.h2('竖直吸附'),
        HtmlText.p('释放后，红色方块将自动吸附到上侧或下侧（较近的一边）。'),
        _AdsorbShowcase(strategy: AdsorbStrategy.vertical),
        Divider(),
        HtmlText.h2('不吸附'),
        HtmlText.p('释放后，红色方块将保持所在位置。'),
        _AdsorbShowcase(strategy: AdsorbStrategy.none),
        Divider(),
        HtmlText.h2('额外偏移'),
        HtmlText.p('可以通过 insets 参数来设置吸附时的额外偏移（支持正负值）。'),
        Row(
          children: [
            _AdsorbShowcase(
              strategy: AdsorbStrategy.both,
              insets: EdgeInsets.all(10),
            ),
            SizedBox(width: 12),
            _AdsorbShowcase(
              strategy: AdsorbStrategy.both,
              insets: EdgeInsets.all(-10),
            ),
          ],
        )
      ],
    );
  }
}
