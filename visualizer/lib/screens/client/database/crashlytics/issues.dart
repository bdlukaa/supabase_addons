import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';

import 'package:visualizer/models/session.dart';

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
    List<Iterable<Map<String, dynamic>>> stackederrors,
  ) {
    final List<DataRow> rows = [];

    for (final serrorlist in stackederrors) {
      // safe to call .first cuz there are no empty lists inside
      final error = serrorlist.first;
      final firstElement = error['stacktraceelements'].first;

      final date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(error['timestamp']));
      final datarow = DataRow(
        onSelectChanged: (_) {},
        cells: [
          DataCell(Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${stackederrors.length}',
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
          DataCell(Text(error['fatal'] ? 'Yes' : 'No')),
          DataCell(Text(error['version'] ?? 'Not specified')),
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

    // TODO: this should be in another thread
    List<List<Map<String, dynamic>>> stackedErrors = [];
    for (final error in widget.errors!) {
      // if there are no errors stacked, add the first
      if (stackedErrors.length == 0) {
        stackedErrors.add([error]);
      } else {
        /// A list of functions that will be executed when the iterators
        /// stop iterating. This is necessary because we can't add an item
        /// to a list while it's being iterated
        List<Function()> toBeExecuted = [];
        // since it's not empty, we iterate trough it
        for (final serrorlist in stackedErrors) {
          final serrorlistindex = stackedErrors.indexOf(serrorlist);
          // and then we iterate trough the inner lists
          for (final serror in serrorlist) {
            print(serror);
            // final listindex = serrorlist.indexOf(serror);
            // if exceptions are the same, stack them on the same list
            if (serror['exception'].toString().trim() ==
                error['exception'].toString().trim()) {
              toBeExecuted.add(() {
                stackedErrors[serrorlistindex].add(error);
              });
            } else {
              // otherwise, create a new list to be stacked
              toBeExecuted.add(() {
                stackedErrors[serrorlistindex].add(error);
              });
            }
          }
        }
        for (final function in toBeExecuted) {
          function();
        }
      }
    }

    return Card(
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
            const DataColumn(label: SelectableText('Exception')),
            const DataColumn(label: Text('Fatal')),
            const DataColumn(label: Text('Version')),
            DataColumn(
              label: const SelectableText('Since'),
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
