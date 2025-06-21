import 'package:bad_fl/widgets.dart';
import 'package:flutter/material.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool ok = true;

  bool handleToggle(to) {
    final v = ok;
    setState(() {
      ok = !ok;
    });
    return v;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BadText(
              'onWillChange',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: BadText('下次点击将切换${ok ? '成功' : '失败'}'),
            ),
            BadSwitch(onWillChange: handleToggle),
            const Divider(),
            const BadText(
              'async handler',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: BadText('点击后将等待1s, 然后切换状态'),
            ),
            BadSwitch(
              onWillChange: (to) async {
                await Future.delayed(const Duration(seconds: 1));
                return true;
              },
            ),
          ],
        ),
      ),
    );
  }
}
