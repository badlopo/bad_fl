import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class PrefabBackToTopView extends StatefulWidget {
  const PrefabBackToTopView({super.key});

  @override
  State<StatefulWidget> createState() => _PrefabBackToTopViewState();
}

class _PrefabBackToTopViewState extends State<PrefabBackToTopView> {
  final List<Color> colors = [Colors.red, Colors.blue, Colors.orange];
  final ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('BackToTop Examples')),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BadBackToTop.animated(
            scrollController: sc,
            child: const BadText('animated'),
          ),
          const SizedBox(width: 16),
          BadBackToTop(scrollController: sc, child: const BadText('jump')),
        ],
      ),
      body: ListView.builder(
        controller: sc,
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (_, index) {
          return Container(
            height: 300,
            margin: const EdgeInsets.only(bottom: 16),
            color: colors[index % 3],
          );
        },
      ),
    );
  }
}
