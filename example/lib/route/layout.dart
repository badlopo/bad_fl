part of 'route.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)!.settings.name;

    return Scaffold(
      appBar: AppBar(title: Text('current: $current')),
      body: Row(
        children: [
          SizedBox(
            width: 240,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final entry in routeNames.entries)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(entry.key);
                    },
                    child: Text(entry.value),
                  ),
              ],
            ),
          ),
          VerticalDivider(width: 1, thickness: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
