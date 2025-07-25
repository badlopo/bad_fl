import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class ExpansiblePage extends StatelessWidget {
  const ExpansiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        BadExpansible(
          headerBuilder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BadText(
                    'Current: ${controller.isExpanded ? 'Expanded' : 'Collapsed'}'),
                const Divider(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.toggle(),
                      child: const BadText('Toggle'),
                    ),
                    ElevatedButton(
                      onPressed: () => controller.expand(),
                      child: const BadText('Expand'),
                    ),
                    ElevatedButton(
                      onPressed: () => controller.collapse(),
                      child: const BadText('Collapse'),
                    ),
                  ],
                ),
              ],
            );
          },
          child: Container(
            height: 400,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
