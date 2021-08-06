import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';

import 'package:visualizer/models/session.dart';

import 'error_dialog.dart';

class IssuesCard extends StatefulWidget {
  const IssuesCard({Key? key, required this.errors}) : super(key: key);

  final List<Map<String, dynamic>>? errors;

  @override
  _IssuesCardState createState() => _IssuesCardState();
}

class _IssuesCardState extends State<IssuesCard> {
  int _currentSortColumn = 3;
  bool _isAscending = false;

  List<DataRow> _getRowsFromStackedErrors(
    Map<String, List<Map<String, dynamic>>> stackederrors,
  ) {
    final List<DataRow> rows = [];

    for (final serrorlist in stackederrors.values) {
      // safe to call .first cuz there are no empty lists inside
      final error = serrorlist.first;
      final firstElement = error['stacktraceelements'].first;

      final date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(error['timestamp']));
      final datarow = DataRow(
        onSelectChanged: (_) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(errors: serrorlist);
            }
          );
        },
        cells: [
          DataCell(Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${serrorlist.length}',
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          )),
          DataCell(RichText(
            text: TextSpan(children: [
              TextSpan(
                text: error['exception'] + '\n',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              TextSpan(
                text: firstElement['file'],
                style: Theme.of(context).textTheme.caption,
              ),
              TextSpan(text: ' ln ${firstElement['line']}'),
            ]),
          )),
          DataCell(Text(error['info']['fatal'] ?? false ? 'Yes' : 'No')),
          DataCell(Text(serrorlist.firstWhere(
            (element) => element['info']['version'] != null,
            orElse: () => {'info': {'version': 'Not specified'}},
          )['info']['version'])),
          DataCell(Text(DateFormat.MMMMEEEEd().format(date))),
          DataCell(
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                // TODO: remove error from database
              },
              tooltip: 'Mark as fixed',
              splashRadius: 20,
            ),
          ),
        ],
      );

      rows.add(datarow);
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errors == null) return const SizedBox.shrink();

    if (widget.errors!.isEmpty) {
      return Center(
        child: SizedBox(
          height: 500,
          width: 500,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SelectableText(
              'You have no issues reported until now!',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Divider(),
            SelectableText.rich(TextSpan(
              text: 'That can mean two things: ',
              children: [
                TextSpan(
                  text: 'the user is not dumb',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                TextSpan(text: ' or '),
                TextSpan(
                  text: 'you did a great job!',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ))
          ]),
        ),
      );
    }

    // TODO: this should be in another thread
    Map<String, List<Map<String, dynamic>>> stackedErrors = {};
    for (final error in widget.errors!) {
      // if there are no errors stacked, add the first
      if (stackedErrors.length == 0) {
        stackedErrors.addAll({
          error['exception']: [error],
        });
      } else {
        if (stackedErrors.containsKey(error['exception'])) {
          stackedErrors[error['exception']]!.add(error);
        } else {
          stackedErrors[error['exception']] = [error];
        }
      }
    }

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _currentSortColumn,
            sortAscending: _isAscending,
            showCheckboxColumn: false,
            columns: [
              const DataColumn(label: SizedBox.shrink()),
              const DataColumn(label: Text('Exception')),
              const DataColumn(label: Text('Fatal')),
              const DataColumn(label: Text('Version')),
              DataColumn(
                label: const Text('Since'),
                onSort: (column, ascending) {
                  setState(() {
                    _isAscending = ascending;
                    widget.errors!.sort((a, b) {
                      final int timestampA = int.parse(a['timestamp']);
                      final int timestampB = int.parse(b['timestamp']);
                      if (ascending) {
                        return timestampB.compareTo(timestampA);
                      } else {
                        return timestampA.compareTo(timestampB);
                      }
                    });
                  });
                },
              ),
              const DataColumn(label: SizedBox.shrink()),
            ],
            rows: _getRowsFromStackedErrors(stackedErrors),
          ),
        ),
      ),
    );
  }

  Future<void> deleteField() async {
    final result = await loggedClient
        .from('crashlytics')
        .delete(returning: ReturningOption.minimal)
        .execute();
    if (result.error != null) {
      throw result.error!;
    }
  }
}
