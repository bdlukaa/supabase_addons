import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:visualizer/models/session.dart';

class AnalyticsDangerZone extends StatefulWidget {
  const AnalyticsDangerZone({Key? key}) : super(key: key);

  @override
  _AnalyticsDangerZoneState createState() => _AnalyticsDangerZoneState();
}

class _AnalyticsDangerZoneState extends State<AnalyticsDangerZone> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          SelectableText(
            'Danger Zone',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 6.0),
          const Expanded(child: Divider(color: Colors.red)),
        ]),
        SelectableText(
          'Be careful around here',
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: Colors.redAccent,
              ),
        ),
        ListTile(
          title: const SelectableText('Keep the data in the last 30 days'),
          subtitle: const SelectableText(
              'Clear all the data that is currently on the database, except the ones that are from back 30 days'),
          trailing: ElevatedButton(
            child: const Text('CLEAR'),
            onPressed: () async {
              try {
                await wipeData(
                  since: DateTime.now().subtract(Duration(days: 30)),
                );
              } on PostgrestError catch (error) {
                print(error.message);
              }
            },
          ),
        ),
        const Divider(),
        ListTile(
          title: const SelectableText('Clear all data'),
          subtitle: const SelectableText(
              'Clear all the data that is currently on the database'),
          trailing: ElevatedButton(
            child: const Text('CLEAR THE DATABASE'),
            onPressed: () async {
              try {
                await wipeData();
              } on PostgrestError catch (error) {
                print(error.message);
              }
            },
          ),
        ),
      ]),
    );
  }
}
