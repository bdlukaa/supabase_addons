import 'package:flutter/material.dart';

import 'database/analytics.dart';

class LoggedClient extends StatefulWidget {
  const LoggedClient({Key? key}) : super(key: key);

  @override
  _LoggedClientState createState() => _LoggedClientState();
}

class _LoggedClientState extends State<LoggedClient> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        TabBar(
          tabs: [
            Tab(text: 'Analytics'),
            Tab(text: 'Crashlytics'),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TabBarView(
              children: [
                AnalyticsScreen(),
                Container(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
