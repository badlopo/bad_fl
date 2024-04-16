import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/layout/panel.dart';
import 'package:example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Map<String, List<(String, String)>> panelSections = {
  'Helper': [
    ('Debounce', NamedRoute.debounce),
    ('Throttle', NamedRoute.throttle),
  ],
  'Impl': [
    ('Request', NamedRoute.request),
  ],
  'Layout': [
    ('Expandable', NamedRoute.panel),
    ('Panel', NamedRoute.panel),
    ('Refreshable', NamedRoute.refreshable),
  ],
  'Mixin': [
    ('SearchMixin', NamedRoute.search),
  ],
  'Prefab': [
    ('Checkbox', NamedRoute.checkbox),
    ('Text', NamedRoute.text),
  ],
  'Wrapper': [
    ('Clickable', NamedRoute.clickable),
  ]
};

const forwardIcon = Icon(Icons.arrow_forward_ios_rounded, size: 16);

class BootPage extends StatelessWidget {
  const BootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Bad FL')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: panelSections.entries
            .map(
              (section) => BadPanel(
                options: BadPanelOptions(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: BadText(section.key, color: Colors.black54),
                  ),
                  dividerColor: Colors.black12,
                ),
                items: section.value
                    .map(
                      (item) => BadPanelItem(
                        label: BadText(item.$1),
                        suffix: forwardIcon,
                        onTap: () => Get.toNamed(item.$2),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
