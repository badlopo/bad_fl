import 'dart:js_interop';

import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

// class Example extends StatelessWidget {
//   const Example({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           BadPanel(
//             title: const Padding(
//               padding: EdgeInsets.only(bottom: 8),
//               child: Text('Profile'),
//             ),
//             items: const [
//               BadPanelItem(
//                 label: Text('Avatar'),
//                 suffix: CircleAvatar(
//                   radius: 18,
//                   backgroundImage: NetworkImage('https://picsum.photos/200'),
//                 ),
//               ),
//               BadPanelItem(
//                 label: Text('Nickname'),
//                 body: Text('nickname', textAlign: TextAlign.end),
//                 suffix: Icon(Icons.edit_note),
//               ),
//               BadPanelItem(
//                 label: Text('HomePage'),
//                 body: Text('https://example.com', textAlign: TextAlign.end),
//               ),
//               BadPanelItem(
//                 label: Text('About'),
//                 body: Text(
//                   'lorem ipsum dolor sit amet, consectetur adipiscing elit',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

@JS('saveImage')
external JSVoid saveImage(JSUint8Array bytes);

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final controller = BadSnapshotController();

  void takeSnapshot() async {
    final image = await controller.captureAsPngBuffer();
    saveImage(image.toJS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: takeSnapshot,
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BadSnapshot(
            controller: controller,
            child: BadPanel(
              title: const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Profile'),
              ),
              items: const [
                BadPanelItem(
                  label: Text('Avatar'),
                  suffix: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://picsum.photos/200'),
                  ),
                ),
                BadPanelItem(
                  label: Text('Nickname'),
                  body: Text('nickname', textAlign: TextAlign.end),
                  suffix: Icon(Icons.edit_note),
                ),
                BadPanelItem(
                  label: Text('HomePage'),
                  body: Text('https://example.com', textAlign: TextAlign.end),
                ),
                BadPanelItem(
                  label: Text('About'),
                  body: Text(
                    'lorem ipsum dolor sit amet, consectetur adipiscing elit',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
