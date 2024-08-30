import 'package:bad_fl/bad_fl.dart';
import 'package:example/constant.dart';
import 'package:flutter/material.dart';

class PrefabExpandableView extends StatefulWidget {
  const PrefabExpandableView({super.key});

  @override
  State<PrefabExpandableView> createState() => _PrefabExpandableViewState();
}

class _PrefabExpandableViewState extends State<PrefabExpandableView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Expandable Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BadExpandableSimple(
            headerBuilder: (state) => Row(
              children: [
                const Expanded(
                  child: BadText(
                    'Lorem Ipsum (Paragraph 1)',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BadText(switch (state) {
                  BadExpandableState.open => 'click to fold',
                  BadExpandableState.close => 'click to expand',
                  BadExpandableState.empty => 'no content',
                }),
              ],
            ),
            gap: 16,
            child: const BadText(loremIpsum1, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          BadExpandableSimple(
            headerBuilder: (state) => Row(
              children: [
                const Expanded(
                  child: BadText(
                    'Lorem Ipsum (Paragraph 2)',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BadText(switch (state) {
                  BadExpandableState.open => 'click to fold',
                  BadExpandableState.close => 'click to expand',
                  BadExpandableState.empty => 'no content',
                }),
              ],
            ),
            gap: 16,
            child: const BadText(loremIpsum2, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          BadExpandableSimple(
            headerBuilder: (state) => Row(
              children: [
                const Expanded(
                  child: BadText(
                    'Lorem Ipsum (Paragraph 3)',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                BadText(switch (state) {
                  BadExpandableState.open => 'click to fold',
                  BadExpandableState.close => 'click to expand',
                  BadExpandableState.empty => 'no content',
                }),
              ],
            ),
            gap: 16,
            child: const BadText(loremIpsum3, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
