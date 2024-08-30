import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class PrefabFloatingView extends StatelessWidget {
  const PrefabFloatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Floating Examples')),
      body: LayoutBuilder(builder: (_, constraint) {
        return Stack(
          children: [
            Container(
              width: constraint.maxWidth,
              height: constraint.maxHeight,
              color: Colors.grey[200],
            ),
            BadFloating(
              containerSize: Size(constraint.maxWidth, constraint.maxHeight),
              floatingSize: const Size(50, 50),
              initialPosition: const BadFloatingPosition.br(50, 50),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green[300],
                ),
                alignment: Alignment.center,
                child: const BadText(
                  'DRAG\nME !',
                  color: Colors.white,
                  fontSize: 12,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
