import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:url_launcher/link.dart';

import 'database/analytics.dart';
import 'database/crashlytics.dart';
import 'database/performance.dart';

class LoggedClient extends StatefulWidget {
  const LoggedClient({Key? key}) : super(key: key);

  @override
  LoggedClientState createState() => LoggedClientState();
}

class LoggedClientState extends State<LoggedClient>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final analyticsKey = GlobalKey<AnalyticsScreenState>();
  final crashlyticsKey = GlobalKey<CrashlyticsState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void reload() {
    switch (tabController.index) {
      case 0:
        // handle analytics reloading
        analyticsKey.currentState?.loadData();
        break;
      case 1:
        crashlyticsKey.currentState?.loadData();
        // handle crashlytics reloading
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TabBar(
        controller: tabController,
        tabs: [
          Tab(text: 'Analytics'),
          Tab(text: 'Crashlytics'),
          Tab(text: 'Performance'),
        ],
      ),
      Expanded(
        child: TabBarView(controller: tabController, children: [
          AnalyticsScreen(key: analyticsKey),
          Crashlytics(key: crashlyticsKey),
          Performance(),
        ]),
      ),
    ]);
  }
}

Widget buildSomethingWentWrong([PostgrestError? error]) {
  return Builder(builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.bug_report),
          const SizedBox(width: 4.0),
          SelectableText(
            'Something went wrong',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ]),
        Divider(),
        SelectableText(
          'An unexpected error happened while fetching your data',
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
        if (error != null)
          Container(
            margin: EdgeInsets.only(top: 6.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: kElevationToShadow[8],
            ),
            padding: EdgeInsets.all(12.0),
            child: SelectableText.rich(TextSpan(
              children: [
                TextSpan(
                  text: 'Error info\n',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextSpan(
                  text: 'Error code: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '${error.code}\n'),
                TextSpan(
                  text: 'Error message: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '${error.message}'),
              ],
            )),
          ),
      ],
    );
  });
}

Widget buildWrongCredentials() {
  return Builder(builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your credentials are not correct',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        Divider(),
        Text(
          'Sign out and make sure they are valid',
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  });
}

Widget buildTableMissing({
  required String title,
  required String tableName,
  required String link,
}) {
  return Builder(builder: (context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          '$title is not set up correctly',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        Divider(),
        RichText(
          text: TextSpan(
            text: 'Create a table called "$tableName" on your database. ',
            children: [
              WidgetSpan(
                child: Link(
                  uri: Uri.parse(link),
                  builder: (context, followLink) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: followLink,
                        child: Text(
                          'Learn more',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  });
}
