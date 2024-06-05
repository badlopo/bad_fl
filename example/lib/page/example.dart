import 'package:bad_fl/bad_fl.dart';
import 'package:bad_fl/wrapper/floating.dart';
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

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BadFloating')),
      body: LayoutBuilder(builder: (_, constraint) {
        return Stack(
          children: [
            Container(
              width: constraint.maxWidth,
              height: constraint.maxHeight,
              color: Colors.grey[200],
            ),
            BadFloating(
              containerSize: Size(constraint.maxWidth, constraint.maxHeight),
              floatingSize: const Size(50, 50),
              initialPosition: const BadFloatingPosition.br(50, 50),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green[300],
                ),
                // child: Text('xxx'),
              ),
            ),
          ],
        );
      }),
    );
  }
}
