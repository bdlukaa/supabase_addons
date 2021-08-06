import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import '../root.dart';
import '../../../constants.dart';
import '../../../models/session.dart';

import 'analytics/danger_zone.dart';
import 'analytics/user_session_event.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Map<String, dynamic>>? user_session;
  dynamic error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() {
    setState(() => user_session = error = null);
    getData(
      'user_session',
      DateTime.now().subtract(Duration(days: 7)),
    ).then((value) {
      if (mounted) setState(() => user_session = value);
    }).catchError((error) {
      if (mounted) setState(() => this.error = error);
    });
  }

  Future<List<Map<String, dynamic>>> getData(
    String eventName,
    DateTime since,
  ) async {
    final result = await loggedClient
        .from('analytics')
        .select()
        .eq('name', eventName)
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
                  title: 'Analytics',
                  tableName: 'analytics',
                  link:
                      'https://github.com/bdlukaa/supabase_addons/tree/master/supabase_addons#get-started-with-analytics',
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
      Wrap(children: [
        DemographicsChart(data: user_session),
        PlatformsChart(data: user_session),
      ]),
      AnalyticsDangerZone(),
    ]);
  }
}
