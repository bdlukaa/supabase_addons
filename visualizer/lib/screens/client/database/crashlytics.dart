import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import '../../../constants.dart';
import '../../../models/session.dart';
import '../root.dart';

import 'crashlytics/issues.dart';

class Crashlytics extends StatefulWidget {
  const Crashlytics({Key? key}) : super(key: key);

  @override
  _CrashlyticsState createState() => _CrashlyticsState();
}

class _CrashlyticsState extends State<Crashlytics> {
  List<Map<String, dynamic>>? errors;
  dynamic error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    getData(
      DateTime.now().subtract(Duration(days: 7)),
    ).then((value) {
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
    return ListView(padding: kListPadding, children: [
      Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Issues', style: Theme.of(context).textTheme.headline5),
              Text(
                'The issues found in your app',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        if (errors == null)
          Center(
            child: Container(
              width: 24.0,
              height: 24.0,
              margin: EdgeInsets.only(right: 4.0),
              child: CircularProgressIndicator.adaptive(strokeWidth: 2.0),
            ),
          ),
      ]),
      IssuesCard(errors: errors),
    ]);
  }
}
