import 'package:bad_fl/widgets.dart';
import 'package:flutter/material.dart';

class PopupPage extends StatefulWidget {
  const PopupPage({super.key});

  @override
  State<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  final pc1 = BadPopupController(false);
  final pc2 = BadPopupController(false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BadText(
            'onTapOutside',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          BadPopup(
            controller: pc1,
            offset: const Offset(10, 10),
            onTapOutside: () {
              pc1.hide();
            },
            popup: Container(
              width: 50,
              height: 30,
              color: Colors.green,
            ),
            childBuilder: (_, visible) {
              return ElevatedButton(
                onPressed: () => pc1.show(),
                child: BadText(
                  visible
                      ? 'click outside to hide popup'
                      : 'click me to show popup',
                ),
              );
            },
          ),
          const Divider(),
          const BadText(
            'Shared Controller',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => pc2.show(),
                child: const BadText('show popup'),
              ),
              ElevatedButton(
                onPressed: () => pc2.hide(),
                child: const BadText('hide popup'),
              ),
            ],
          ),
          BadPopup(
            controller: pc2,
            origin: Alignment.centerRight,
            popupOrigin: Alignment.centerLeft,
            offset: const Offset(10, 0),
            popup: const BadText('Popup element 1', fontSize: 12),
            childBuilder: (_, visible) {
              return const BadText('Host element 1', lineHeight: 24);
            },
          ),
          BadPopup(
            controller: pc2,
            origin: Alignment.centerRight,
            popupOrigin: Alignment.centerLeft,
            offset: const Offset(10, 0),
            popup: const BadText('Popup element 2', fontSize: 12),
            childBuilder: (_, visible) {
              return const BadText('Host element 2', lineHeight: 24);
            },
          ),
          BadPopup(
            controller: pc2,
            origin: Alignment.centerRight,
            popupOrigin: Alignment.centerLeft,
            offset: const Offset(10, 0),
            popup: const BadText('Popup element 3', fontSize: 12),
            childBuilder: (_, visible) {
              return const BadText('Host element 3', lineHeight: 24);
            },
          ),
        ],
      ),
    );
  }
}
