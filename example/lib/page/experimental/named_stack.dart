import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class NamedStackPage extends StatefulWidget {
  const NamedStackPage({super.key});

  @override
  State<NamedStackPage> createState() => _NamedStackPageState();
}

class _NamedStackPageState extends State<NamedStackPage> {
  String name = 'aaa';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final n in const ['aaa', 'bbb', 'ccc', 'ddd'])
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      name = n;
                    });
                  },
                  child: BadText('to $n'),
                )
            ],
          ),
        ),
        const Divider(),
        BadNamedStack(
          name: name,
          layers: const [
            BadNamedStackLayer(name: 'aaa', child: _AsyncPage(name: 'aaa')),
            BadNamedStackLayer(name: 'bbb', child: _AsyncPage(name: 'bbb')),
            BadNamedStackLayer(name: 'ccc', child: _AsyncPage(name: 'ccc')),
            BadNamedStackLayer(name: 'ddd', child: _AsyncPage(name: 'ddd')),
          ],
        )
      ],
    );
  }
}

class _AsyncPage extends StatefulWidget {
  final String name;

  const _AsyncPage({required this.name});

  @override
  State<_AsyncPage> createState() => _AsyncPageState();
}

class _AsyncPageState extends State<_AsyncPage> {
  bool loaded = false;

  void boot() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    boot();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BadText('Page ${widget.name}'),
        loaded
            ? const BadText('Loaded')
            : const BadSpinner(child: Icon(Icons.refresh)),
      ],
    );
  }
}
