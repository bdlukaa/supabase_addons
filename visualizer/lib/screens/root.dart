import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import 'package:visualizer/constants.dart';
import 'package:visualizer/models/session.dart';

import 'auth/log_in.dart';
import 'client/root.dart';
import 'introduction_screen.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/supabase_logo.png'),
        ),
        title: Row(children: [
          SelectableText('Supabase Addons Visualizer'),
          const SizedBox(width: 6.0),
          Chip(
            label: SelectableText('Alpha'),
            backgroundColor: Colors.redAccent,
          ),
        ]),
        actions: [
          Link(
            uri: Uri.parse(projectRepository),
            target: LinkTarget.blank,
            builder: (context, followLink) => IconButton(
              icon: ImageIcon(AssetImage('assets/github_logo.png'), size: 30.0),
              splashRadius: 20.0,
              onPressed: followLink,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Link(
              uri: Uri.parse(
                'https://github.com/bdlukaa/supabase_addons/tree/master/supabase_addons',
              ),
              target: LinkTarget.blank,
              builder: (context, followLink) => OutlinedButton(
                child: Text('Documentation'),
                onPressed: followLink,
              ),
            ),
          ),
          if (hasClient) ...[
            // TODO: get Refresh button working
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
              tooltip: 'Refresh',
              splashRadius: 20.0,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                child: Text('Sign out'),
                onPressed: () {
                  setState(() => client = null);
                },
              ),
            ),
          ],
        ],
      ),
      body: () {
        if (hasClient) return LoggedClient();
        return Row(children: [
          Expanded(child: LogIn(onUpdate: () => setState(() {}))),
          VerticalDivider(),
          Expanded(child: IntroductionScreen()),
        ]);
      }(),
      bottomNavigationBar: Container(
        height: 40.0,
        color: const Color(0xFF818cf8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(width: 26.0),
          Link(
            uri: Uri.parse(discordLink),
            builder: (context, followLink) => ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back, size: 18.0),
              label: const Text('Join my discord server'),
              onPressed: followLink,
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF312e81),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          VerticalDivider(),
          Link(
            uri: Uri.parse(supabaseDiscordLink),
            target: LinkTarget.blank,
            builder: (context, followLink) => ElevatedButton(
              child: Row(children: [
                const Text('Join Supabase Discord server'),
                const SizedBox(width: 4.0),
                const Icon(Icons.arrow_forward, size: 18.0)
              ]),
              onPressed: followLink,
              style: ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ),
        ]),
      ),
    );
  }
}
