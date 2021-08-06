import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<Map<String, dynamic>> errors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 700,
        child: Card(
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event summary',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.start,
                  ),
                  TabBar(tabs: [
                    Tab(text: 'Stacktrace'),
                    Tab(text: 'More info'),
                  ]),
                  Expanded(
                    child: TabBarView(children: [
                      _buildStacktrace(),
                      _buildMoreInfo(),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStacktrace() {
    final error = errors.first;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Text('${error['stacktraceelements']}'),
    );
  }

  Widget _buildMoreInfo() {
    final error = errors.first;

    final date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(error['timestamp']));

    return ListView(children: [
      ListTile(
        leading: Icon(Icons.event),
        title: Text('Happened at'),
        subtitle: Text(DateFormat.MMMMEEEEd().format(date)),
      ),
      ListTile(
        leading: Icon(Icons.snooze),
        title: Text('Version'),
        subtitle: Text(error['version'] ?? 'Not provided'),
      ),
    ]);
  }
}
