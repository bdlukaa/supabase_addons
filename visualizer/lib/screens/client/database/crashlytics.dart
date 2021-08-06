import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';

import '../../../constants.dart';
import '../../../models/session.dart';
import '../root.dart';

import 'crashlytics/issues.dart';

class Crashlytics extends StatefulWidget {
  const Crashlytics({Key? key}) : super(key: key);

  @override
  CrashlyticsState createState() => CrashlyticsState();
}

class CrashlyticsState extends State<Crashlytics> {
  static List<DateTime> times = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 7)),
    DateTime.now().subtract(Duration(days: 14)),
    DateTime.now().subtract(Duration(days: 30)),
    DateTime.now().subtract(Duration(days: 30 * 6)),
    DateTime.now().subtract(Duration(days: 30 * 12)),
  ];

  int since = 1;

  List<Map<String, dynamic>>? errors;
  dynamic error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() {
    setState(() => errors = error = null);
    getData(times[since]).then((value) {
      if (mounted) setState(() => errors = value);
    }).catchError((error) {
      if (mounted) setState(() => this.error = error);
    });
  }

  Future<List<Map<String, dynamic>>> getData(
    DateTime since,
  ) async {
    final result = await loggedClient
        .from('crashlytics')
        .select()
        .gte('timestamp', since.millisecondsSinceEpoch)
        .execute();
    if (result.error != null) {
      throw result.error!;
    } else {
      return (result.data as List).cast<Map<String, dynamic>>();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: SizedBox(
          width: 500,
          height: 500,
          child: () {
            if (error is PostgrestError) {
              if (error.message == kInvalidCredentialsErrorMessage) {
                return buildWrongCredentials();
              }
              if (error.code == kUndefinedTableErrorCode) {
                return buildTableMissing(
                  title: 'Crashlytics',
                  tableName: 'crashlytics',
                  link:
                      'https://github.com/bdlukaa/supabase_addons/tree/master/supabase_addons#get-started-with-crashlytics',
                );
              }
              return buildSomethingWentWrong(error);
            }
            return buildSomethingWentWrong();
          }(),
        ),
      );
    }
    return Padding(
      padding: kListPadding,
      child: Column(children: [
        Row(children: [
          Expanded(
            child: SelectableText.rich(TextSpan(children: [
              TextSpan(
                text: 'Issues\n',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextSpan(
                text: 'The issues found in your app',
                style: Theme.of(context).textTheme.caption,
              ),
            ])),
          ),

          Container(
            margin: EdgeInsets.only(right: 12.0),
            padding: EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: since,
                onChanged: (value) {
                  if (value != null && since != value) {
                    since = value;
                    loadData();
                  }
                },
                items: [
                  DropdownMenuItem(
                    child: Text('since today'),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text('since 7 days ago'),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text('since 14 days ago'),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text('since 30 days ago'),
                    value: 3,
                  ),
                  DropdownMenuItem(
                    child: Text('since 6 months ago'),
                    value: 4,
                  ),
                  DropdownMenuItem(
                    child: Text('since a year ago'),
                    value: 5,
                  ),
                ],
              ),
            ),
          ),

          // TODO: sorting. change the `since` time. It should default to 7 days back
          if (errors == null)
            Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                margin: EdgeInsets.only(right: 4.0),
                child: CircularProgressIndicator.adaptive(strokeWidth: 2.0),
              ),
            )
          else
            SelectableText(
              '${NumberFormat.compactLong().format(errors!.length)}',
            ),
        ]),
        Expanded(child: IssuesCard(errors: errors)),
      ]),
    );
  }
}
