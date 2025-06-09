import 'package:bad_fl/bad_fl.dart';
import 'package:example/component/html_text.dart';
import 'package:example/layout/page_layout.dart';
import 'package:flutter/material.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BadText(
                'Width & Height',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const BadShimmer(
                width: 320,
                height: 32,
                margin: EdgeInsets.symmetric(vertical: 12),
              ),
              const BadText(
                'Border & Border Radius & Background',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
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
              ),
              const BadText(
                'Shimmer direction',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: BadText(
                  'Combination',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          ),
        ),
      ),
    );
  }
}
