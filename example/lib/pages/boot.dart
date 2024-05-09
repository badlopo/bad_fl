import 'package:bad_fl/prefab/button.dart';
import 'package:bad_fl/prefab/text.dart';
import 'package:bad_fl/layout/panel.dart';
import 'package:bad_fl_example/routes/name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const prefabs = [
  // ('Button', NamedRoute.button),
  // ('Checkbox', NamedRoute.checkbox),
  ('OTPInput', NamedRoute.otpInput),
  ('PasswordInput', NamedRoute.passwordInput),
  // ('Switch', NamedRoute.switch_),
  // ('Text', NamedRoute.text),
  // ('TextField', NamedRoute.textField),
  ('TextInput', NamedRoute.textInput),
];

const forwardIcon = Icon(Icons.arrow_right, size: 16);

class BootPage extends StatelessWidget {
  const BootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const BadText('Bad FL')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BadPanel(
            options: const BadPanelOptions(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: BadText('Prefabs', fontWeight: FontWeight.w500),
              ),
              dividerColor: Colors.black12,
            ),
            items: prefabs
                .map(
                  (item) => BadPanelItem(
                    label: BadText(item.$1),
                    suffix: forwardIcon,
                    onTap: () => Get.toNamed(item.$2),
                  ),
                )
                .toList(),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Hero(
              tag: 'test',
              child: Container(
                width: 20,
                height: 100,
                color: Colors.orange,
              ),
            ),
          ),
          BadButton(
            height: 32,
            onPressed: () => Get.toNamed(NamedRoute.misc),
            child: const BadText('to /misc'),
          ),
        ],
      ),
    );
  }
}
