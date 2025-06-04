import 'package:bad_fl/bad_fl.dart';
import 'package:example/component/html_text.dart';
import 'package:example/layout/page_layout.dart';
import 'package:flutter/material.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetPageLayout(
      title: 'BadShimmer',
      description: r'一个带闪光动画的小部件, 可用于快速构建任意结构的骨架屏.',
      children: <Widget>[
        const HtmlText.h2('常规'),
        const HtmlText.p('width & height'),
        const Align(
          alignment: Alignment.centerLeft,
          child: BadShimmer(width: 320, height: 32),
        ),
        const HtmlText.h2('边框 & 圆角 & 背景色'),
        const HtmlText.p("border & borderRadius & fill"),
        Row(
          children: [
            const BadShimmer(
              width: 100,
              height: 32,
              border: Border(
                left: BorderSide(color: Colors.red, width: 3),
                top: BorderSide(color: Colors.blue, width: 3),
                right: BorderSide(color: Colors.green, width: 3),
                bottom: BorderSide(color: Colors.orange, width: 3),
              ),
            ),
            const BadShimmer(
              width: 100,
              height: 32,
              margin: EdgeInsets.only(left: 20),
              borderRadius: 8,
            ),
            BadShimmer(
              width: 100,
              height: 32,
              margin: const EdgeInsets.only(left: 20),
              fill: Colors.grey.shade300,
            ),
          ],
        ),
        const HtmlText.h2('方向'),
        const HtmlText.p('direction'),
        const Row(
          children: [
            BadShimmer(
              width: 100,
              height: 100,
              direction: ShimmerDirection.l2r,
            ),
            BadShimmer(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(left: 10),
              direction: ShimmerDirection.r2l,
            ),
            BadShimmer(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(left: 10),
              direction: ShimmerDirection.t2b,
            ),
            BadShimmer(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(left: 10),
              direction: ShimmerDirection.b2t,
            ),
          ],
        ),
        const HtmlText.h2('组合'),
        const HtmlText.p('结合 Row、Column 等布局组件, 可以快速构建任意结构的骨架屏.'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BadShimmer(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              borderRadius: 16,
              fill: Colors.grey.shade300,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BadShimmer(
                  width: 100,
                  height: 32,
                  borderRadius: 8,
                  fill: Colors.grey.shade300,
                ),
                BadShimmer(
                  width: 220,
                  height: 32,
                  margin: const EdgeInsets.only(top: 8),
                  borderRadius: 8,
                  fill: Colors.grey.shade300,
                ),
                BadShimmer(
                  width: 220,
                  height: 120,
                  margin: const EdgeInsets.only(top: 8),
                  borderRadius: 8,
                  fill: Colors.grey.shade300,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
