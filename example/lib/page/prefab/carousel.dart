import 'package:bad_fl/bad_fl.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';

class PrefabCarouselView extends StatelessWidget {
  const PrefabCarouselView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Carousel Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const BadText('Linear Carousel'),
          SizedBox(
            height: 200,
            child: BadCarousel(
              onPageChanged: (index) =>
                  Utils.showSnackBar(context, 'Page changed to ${index + 1}'),
              onSwipeOut: () => Utils.showSnackBar(context, 'Swipe out'),
              indicatorBuilder: (_, index) => Positioned(
                  bottom: 0, child: BadText('Current: ${index + 1}')),
              children: [
                Container(color: Colors.red),
                Container(color: Colors.green),
                Container(color: Colors.blue),
                Container(color: Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const BadText('Cyclic Carousel'),
          SizedBox(
            height: 200,
            child: BadCarouselCyclic(
              onPageChanged: (index) =>
                  Utils.showSnackBar(context, 'Page changed to ${index + 1}'),
              indicatorBuilder: (_, index) => Positioned(
                  bottom: 0, child: BadText('Current: ${index + 1}')),
              children: [
                Container(color: Colors.red),
                Container(color: Colors.green),
                Container(color: Colors.blue),
                Container(color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
