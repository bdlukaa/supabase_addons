import 'package:flutter/material.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arrowStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          color: Theme.of(context).disabledColor,
        );
    final arrow = TextSpan(
      text: ' then ',
      style: arrowStyle!.copyWith(),
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          child: SelectableText.rich(TextSpan(children: [
            TextSpan(
                text: 'Welcome to\n',
                style: Theme.of(context).textTheme.headline6),
            TextSpan(
              text: 'Supabase Addons',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ])),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: FlutterLogo(size: 34.0),
        ),
        Icon(Icons.add),
        Image.asset(
          'assets/supabase_logo.png',
          height: 44,
          width: 44,
        ),
      ]),
      Divider(),
      SelectableText.rich(
        TextSpan(children: [
          TextSpan(
            text: 'How to get my Supabase URL and Annon Key?\n',
            style: Theme.of(context).textTheme.headline6,
          ),
          TextSpan(text: 'Open your Supabase project'),
          arrow,
          TextSpan(text: 'go to Settings'),
          arrow,
          TextSpan(text: 'click on API and'),
          arrow,
          TextSpan(
            // text: 'copy "URL" and "annon public"',
            text: 'copy ',
            children: [
              TextSpan(
                text: 'URL',
                style: TextStyle(color: Colors.blue),
              ),
              TextSpan(text: ' and '),
              TextSpan(
                text: 'annon public',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ]),
      ),
    ]);
  }
}
