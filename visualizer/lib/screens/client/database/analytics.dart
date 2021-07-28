import 'package:flutter/material.dart';
import 'package:visualizer/models/session.dart';

import 'analytics/user_session_event.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Map<String, dynamic>>? user_session;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    getData(
      'user_session',
      DateTime.now().subtract(Duration(days: 7)),
    ).then((value) {
      setState(() => user_session = value);
    }).catchError((error) {
      print(error);
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
    return Wrap(children: [
      DemographicsChart(data: user_session),
      PlatformsChart(data: user_session),
    ]);
  }
}
