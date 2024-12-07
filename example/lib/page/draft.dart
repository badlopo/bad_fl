import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({super.key});

  @override
  State<DraftPage> createState() => _DraftState();
}

class _DraftState extends State<DraftPage> {
  final BadInputController controller1 = BadInputController();
  final BadInputController controller2 = BadInputController();
  final BadInputController controller3 = BadInputController();
  final BadInputController controller4 = BadInputController();
  final BadInputController controller5 = BadInputController();
  final BadInputController controller6 = BadInputController();

  String selected = '-';

  int radio = 1;

  bool checked = false;

  final fdc = FreeDrawController();

  final pc = PopupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft'),
      ),
      body: ListView(
        // physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          BadSimpleInput(
            controller: controller1,
            height: 44,
            border: Border.all(),
            borderRadius: 8,
            clearIcon: const Icon(Icons.clear),
          ),
          BadCommonInput(
            controller: controller2,
            height: 44,
            border: Border.all(),
            borderRadius: 8,
            clearIcon: const Icon(Icons.clear),
            errorIcon: const Icon(Icons.error_outline),
          ),
          BadPhoneInput(
            controller: controller3,
            height: 44,
            border: Border.all(),
            borderRadius: 8,
            prefixIcon: const Icon(Icons.phone),
            slot: Container(
              width: 20,
              color: Colors.red,
            ),
            clearIcon: const Icon(Icons.clear),
            errorIcon: const Icon(Icons.error_outline),
          ),
          BadPasswordInput(
            controller: controller4,
            height: 44,
            border: Border.all(),
            borderRadius: 8,
            prefixIcon: const Icon(Icons.lock),
            visibleIcon: const Icon(Icons.visibility),
            invisibleIcon: const Icon(Icons.visibility_off),
            errorIcon: const Icon(Icons.error_outline),
          ),
          BadOTPInput(
            controller: controller5,
            height: 44,
            border: Border.all(),
            borderRadius: 8,
            prefixIcon: const Icon(Icons.sms),
            errorIcon: const Icon(Icons.error_outline),
            suffixWidget: ElevatedButton(
              onPressed: () {},
              child: Text('Send'),
            ),
          ),
          Text('selected: $selected'),
          ElevatedButton(
            onPressed: () {
              // TODO: misc test
            },
            child: Text('rebuild popup'),
          ),
          BadPopup.builder(
            controller: pc,
            onClickOut: pc.hide,
            popup: BadClickable(
              onClick: pc.hide,
              child: Container(
                width: 50,
                height: 32,
                color: Colors.red,
              ),
            ),
            builder: (_, open) => ElevatedButton(
              onPressed: () {
                pc.show();
              },
              child: Text('show popup (now: $open)'),
            ),
          ),
          // CustomScrollView(slivers: [],),
        ].separateToList(
          convert: asIs,
          separator: const SizedBox(height: 16),
        ),
      ),
    );
  }
}
