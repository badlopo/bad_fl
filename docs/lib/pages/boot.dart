import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/layout/panel.dart';
import 'package:bad_fl_doc/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Map<String, List<(String, String)>> panelSections = {
  'Extension': [
    ('List', NamedRoute.list),
  ],
  'Fragment': [
    ('WebView', NamedRoute.webview),
  ],
  'Helper': [
    ('Debounce', NamedRoute.debounce),
    ('Throttle', NamedRoute.throttle),
  ],
  'Impl': [
    ('Cache', NamedRoute.cache),
    ('Clipboard', NamedRoute.clipboard),
    ('EvCenter', NamedRoute.evCenter),
    ('ImageSelect', NamedRoute.imageSelect),
    ('KvStorage', NamedRoute.kvStorage),
    ('Meta', NamedRoute.meta),
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
    ('Button', NamedRoute.button),
    ('Checkbox', NamedRoute.checkbox),
    ('OTPInput', NamedRoute.otpInput),
    ('PasswordInput', NamedRoute.passwordInput),
    ('Switch', NamedRoute.switch_),
    ('Text', NamedRoute.text),
    ('TextField', NamedRoute.textField),
    ('TextInput', NamedRoute.textInput),
  ],
  'Wrapper': [
    ('Clickable', NamedRoute.clickable),
  ]
};

const forwardIcon = Icon(Icons.arrow_right, size: 16);

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
                    child: BadText(section.key, fontWeight: FontWeight.w500),
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
              ).paddingOnly(bottom: 16),
            )
            .toList(),
      ),
    );
  }
}
