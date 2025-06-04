import 'package:example/route/route.dart';
import 'package:flutter/material.dart';
import 'package:bad_fl/bad_fl.dart';

class _GalleryCard extends StatelessWidget {
  final String routeName;
  final String title;
  final Widget child;

  const _GalleryCard({
    required this.routeName,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      width: 280,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          SizedBox(height: 40, child: BadText(title, lineHeight: 40)),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
          ColoredBox(
            color: Colors.blueGrey.shade50,
            child: SizedBox(
              height: 139,
              child: Center(child: child),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: BadClickable(
        onClick: () {
          Navigator.of(context).pushReplacementNamed(routeName);
        },
        child: inner,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 12,
          runSpacing: 12,
          children: [
            _GalleryCard(
              routeName: RouteNames.button,
              title: 'Button 按钮',
              child: BadButton(
                width: 100,
                height: 32,
                borderRadius: 4,
                fill: Colors.blue,
                onPressed: () {},
                child: const BadText(
                  'Click Me',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            const _GalleryCard(
              routeName: RouteNames.katex,
              title: 'Katex 公式',
              child: BadKatex(raw: r'$E=mc^2$'),
            ),
            const _GalleryCard(
              routeName: RouteNames.shimmer,
              title: 'Shimmer 闪光',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BadShimmer(
                    width: 32,
                    height: 32,
                    margin: EdgeInsets.only(right: 8),
                    borderRadius: 16,
                    fill: Colors.black26,
                  ),
                  BadShimmer(
                    width: 100,
                    height: 32,
                    borderRadius: 8,
                    fill: Colors.black26,
                  ),
                ],
              ),
            ),
            // TODO: add more cards for other widgets
          ],
        ),
      ),
    );
  }
}
