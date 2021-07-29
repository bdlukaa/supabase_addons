import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IssuesCard extends StatefulWidget {
  const IssuesCard({Key? key, required this.errors}) : super(key: key);

  final List<Map<String, dynamic>>? errors;

  @override
  _IssuesCardState createState() => _IssuesCardState();
}

class _IssuesCardState extends State<IssuesCard> {
  int _currentSortColumn = 3;
  bool _isAscending = false;

  @override
  Widget build(BuildContext context) {
    if (widget.errors == null) return SizedBox.shrink();
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _currentSortColumn,
            sortAscending: _isAscending,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Exception')),
              DataColumn(label: Text('Fatal')),
              DataColumn(label: Text('Version')),
              DataColumn(
                label: Text('Since'),
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
              DataColumn(label: SizedBox.shrink()),
            ],
            // TODO: stack errors by 'exception'.
            rows: List.generate(widget.errors!.length, (index) {
              final error = widget.errors![index];

              final firstElement = error['stacktraceelements'].first;

              final date = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(error['timestamp']));
              return DataRow(
                onSelectChanged: (_) {},
                cells: [
                  DataCell(RichText(
                    text: TextSpan(
                      text: '',
                      children: [
                        TextSpan(
                          text: error['exception'] + '\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        TextSpan(
                          text: firstElement['file'],
                          style: Theme.of(context).textTheme.caption,
                        ),
                        TextSpan(
                          text: ' ln ${firstElement['line']}',
                        ),
                      ],
                    ),
                  )),
                  DataCell(Text(error['fatal'] ? 'Yes' : 'No')),
                  DataCell(Text(error['version'] ?? 'Not specified')),
                  DataCell(
                    Text(DateFormat.MMMMEEEEd().format(date)),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        // TODO: remove error from database
                      },
                      tooltip: 'Mark as fixed',
                      splashRadius: 20,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
