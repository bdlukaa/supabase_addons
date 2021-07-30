import 'package:flutter/material.dart';

class Performance extends StatelessWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 500,
        width: 500,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SelectableText(
            'The performance visualizer will be implemented soon',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Divider(),
          SelectableText(
              'Relax, take a break and drink a coffe while you wait'),
        ]),
      ),
    );
  }
}
