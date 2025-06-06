import 'package:bad_fl/bad_fl.dart';
import 'package:example/component/html_text.dart';
import 'package:example/layout/page_layout.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return WidgetPageLayout(
      title: 'BadButton',
      description:
          '使用 Container + GestureDetector 实现按钮功能，舍弃了语义（Semantics）相关的支持和默认按钮的预设样式（间距、圆角、水波纹等），可以更方便地自定义成需要的样式。\n\n添加了对异步任务的支持：onPressed 可以接收一个返回 Future 的处理函数，在执行期间会显示 loadingWidget 并禁用按钮，执行完成后恢复默认状态。',
      children: [
        const HtmlText.h2('常规'),
        Row(
          children: [
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              child: const BadText(
                'filled button',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              border: const Border.fromBorderSide(
                BorderSide(color: Colors.blue),
              ),
              borderRadius: 4,
              onPressed: () {},
              child: const BadText(
                'outlined button',
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
            BadButton(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onPressed: () {},
              child: const BadText(
                'text button',
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Divider(),
        const HtmlText.h2('图标按钮'),
        const HtmlText.p(
            '此变体命名为 BadButton.icon，但实际上主要是为了用于按钮内包含两个子元素的场景，以减少代码嵌套层级。'),
        Row(
          children: [
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              gap: 4,
              icon: const Icon(Icons.send, size: 14, color: Colors.white),
              label: const BadText('Send', color: Colors.white, fontSize: 14),
            ),
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              gap: 4,
              icon: const BadText('Send', color: Colors.white, fontSize: 14),
              label: const Icon(Icons.send, size: 14, color: Colors.white),
            ),
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              gap: 4,
              icon: const Icon(Icons.person, size: 14, color: Colors.white),
              label: const Icon(Icons.search, size: 14, color: Colors.white),
            ),
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              border: const Border.fromBorderSide(
                BorderSide(color: Colors.blue),
              ),
              borderRadius: 4,
              onPressed: () {},
              gap: 4,
              icon: const BadText('Left', color: Colors.red, fontSize: 14),
              label: const BadText('Right', color: Colors.green, fontSize: 14),
            ),
          ],
        ),
        const Divider(),
        const HtmlText.h2('异步支持'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: BadText('count: $_count (click button to add 1)'),
        ),
        Row(
          children: [
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {
                setState(() {
                  _count += 1;
                });
              },
              child: const BadText(
                'Synchronous',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 2));
                setState(() {
                  _count += 1;
                });
              },
              loadingWidget: const BadSpinner(
                child: Icon(Icons.autorenew, color: Colors.white),
              ),
              child: const BadText(
                'Asynchronous, wait for 2s',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
