import 'package:bad_fl/bad_fl.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  int _count1 = 0;
  int _count2 = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              child: const BadText(
                'filled button',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              border: const Border.fromBorderSide(
                BorderSide(color: Colors.blue),
              ),
              borderRadius: 4,
              onPressed: () {},
              child: const BadText(
                'outlined button',
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
            BadButton(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              onPressed: () {},
              child: const BadText(
                'text button',
                color: Colors.blue,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              gap: 4,
              icon: const Icon(Icons.send, size: 14, color: Colors.white),
              label: const BadText('Send', color: Colors.white, fontSize: 14),
            ),
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              gap: 4,
              icon: const BadText('Send', color: Colors.white, fontSize: 14),
              label: const Icon(Icons.send, size: 14, color: Colors.white),
            ),
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {},
              gap: 4,
              icon: const Icon(Icons.person, size: 14, color: Colors.white),
              label: const Icon(Icons.search, size: 14, color: Colors.white),
            ),
            BadButton.icon(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              border: const Border.fromBorderSide(
                BorderSide(color: Colors.blue),
              ),
              borderRadius: 4,
              onPressed: () {},
              gap: 4,
              icon: const BadText('Left Part', color: Colors.red, fontSize: 14),
              label: const BadText('Right Part',
                  color: Colors.green, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () {
                setState(() {
                  _count1 += 1;
                });
              },
              child: BadText(
                '$_count1 | Synchronous',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            BadButton(
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              borderRadius: 4,
              fill: Colors.blue,
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {
                  _count2 += 1;
                });
              },
              loadingWidget: const BadSpinner(
                child: Icon(Icons.autorenew, color: Colors.white),
              ),
              child: BadText(
                '$_count2 | Asynchronous, wait for 1s',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
