import 'package:bad_fl/widgets.dart';
import 'package:flutter/material.dart';

class AnchoredScrollablePage extends StatefulWidget {
  const AnchoredScrollablePage({super.key});

  @override
  State<AnchoredScrollablePage> createState() => _AnchoredScrollablePageState();
}

class _AnchoredScrollablePageState extends State<AnchoredScrollablePage> {
  static const anchorCount = 6;

  final asc = BadAnchoredScrollableController<int>();

  Iterable<Widget> _buildListItems() sync* {
    for (int i = 0; i < anchorCount; i += 1) {
      yield BadScrollAnchor(anchorValue: i, child: Text('Anchor $i'));
      yield Container(
        height: 100 + i * 100,
        color: [Colors.red, Colors.orange, Colors.green][i % 3],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
                'You can control multiple lists with the same "BadAnchoredScrollableController"'),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                for (int i = 0; i < anchorCount; i += 1)
                  ElevatedButton(
                    onPressed: () => asc.jumpToAnchor(i),
                    child: Text('Jump to anchor$i'),
                  ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: BadAnchoredScrollable(
                  controller: asc,
                  scrollController: ScrollController(),
                  children: [
                    ..._buildListItems(),
                  ],
                ),
              ),
              VerticalDivider(),
              Expanded(
                child: BadAnchoredScrollable(
                  controller: asc,
                  scrollController: ScrollController(),
                  children: [
                    ..._buildListItems(),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
