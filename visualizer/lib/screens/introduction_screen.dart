import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          child: SelectableText.rich(TextSpan(children: [
            TextSpan(
              text: 'Welcome to\n',
              style: Theme.of(context).textTheme.headline6,
            ),
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
      const Divider(),
      SelectableText.rich(
        TextSpan(children: [
          TextSpan(
            text: 'How to get my Supabase URL and Annon Key?\n',
            style: Theme.of(context).textTheme.headline6,
          ),
          TextSpan(
            text: '   1. Go to ',
            children: [
              TextSpan(
                text: 'Supabase App',
                mouseCursor: SystemMouseCursors.click,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://app.supabase.io/');
                  },
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(text: '\n'),
            ],
          ),
          TextSpan(text: '   2. Select your project\n'),
          TextSpan(text: '   3. Go to "Settings"\n'),
          TextSpan(text: '   4. Select "API"\n'),
          TextSpan(text: '   5. Under "Config", copy "URL"\n'),
          TextSpan(text: '   6. Under "API Keys", copy "annon" "public"\n'),
          TextSpan(
              text:
                  '   7. Paste both values in their respective slot in the left\n'),
          TextSpan(text: '   8. Enjoy 🎉🥳'),
        ]),
      ),
    ]);
  }
}
