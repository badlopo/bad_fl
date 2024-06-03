import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final RxInt ptr = 0.obs;
  final sc = ScrollController();
  final sac = BadScrollAnchorController<int>();

  @override
  void initState() {
    super.initState();

    sac.addObserver((key, status) {
      if (status == AnchorStatus.show) {
        ptr.value = key;
      } else {
        ptr.value = key + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text('top anchor: $ptr'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => sac.jumpToAnchor(2),
                    child: const Text('jump to 2'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => sac.animateToAnchor(4),
                    child: const Text('animate to 4'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BadScrollAnchorScope(
              controller: sac,
              scrollController: sc,
              padding: const EdgeInsets.all(16),
              children: [
                BadScrollAnchor(
                  asKey: 0,
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.blue,
                    child: const Text('anchor 0'),
                  ),
                ),
                BadScrollAnchor(
                  asKey: 1,
                  child: Container(
                      width: double.infinity,
                      height: 400,
                      color: Colors.grey,
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        children: [
                          const Text('anchor 1'),
                          const SizedBox(height: 50),
                          BadScrollAnchor(
                            asKey: 2,
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.cyan,
                              child: const Text(
                                  'anchor 2\nnested anchor works too!'),
                            ),
                          ),
                        ],
                      )),
                ),
                BadScrollAnchor(
                  asKey: 3,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.green,
                    child: const Text('anchor 3'),
                  ),
                ),
                BadScrollAnchor(
                  asKey: 4,
                  child: Container(
                    width: double.infinity,
                    height: 500,
                    color: Colors.amber,
                    child: const Text('anchor 4'),
                  ),
                ),
                BadScrollAnchor(
                  asKey: 5,
                  child: Container(
                    width: double.infinity,
                    height: 700,
                    color: Colors.teal,
                    child: const Text('anchor 5'),
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
