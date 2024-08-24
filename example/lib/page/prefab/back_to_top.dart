import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class BackToTopView extends StatefulWidget {
  const BackToTopView({super.key});

  @override
  State<StatefulWidget> createState() => _BackToTopViewState();
}

class _BackToTopViewState extends State<BackToTopView> {
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
