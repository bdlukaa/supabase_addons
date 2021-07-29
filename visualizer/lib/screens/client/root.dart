import 'package:flutter/material.dart';

import 'database/analytics.dart';
import 'database/crashlytics.dart';
import 'database/performance.dart';

class LoggedClient extends StatefulWidget {
  const LoggedClient({Key? key}) : super(key: key);

  @override
  _LoggedClientState createState() => _LoggedClientState();
}

class _LoggedClientState extends State<LoggedClient> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(children: [
        TabBar(
          tabs: [
            Tab(text: 'Analytics'),
            Tab(text: 'Crashlytics'),
            Tab(text: 'Performance'),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: TabBarView(children: [
              AnalyticsScreen(),
              Crashlytics(),
              Performance(),
            ]),
          ),
        ),
      ]),
    );
  }
}
