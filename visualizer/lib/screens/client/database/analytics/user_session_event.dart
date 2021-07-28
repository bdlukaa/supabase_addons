import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flag/flag.dart';
import 'package:country_provider/country_provider.dart';
import 'package:intl/intl.dart';

import '../../../../utils.dart';

Widget _headline(String title, [int? total]) {
  return Builder(builder: (context) {
    return Row(children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      if (total != null)
        Text(
          'Total of ${NumberFormat.compactLong().format(total)}',
          textAlign: TextAlign.end,
        )
      else
        CircularProgressIndicator(),
    ]);
  });
}

class DemographicsChart extends StatefulWidget {
  const DemographicsChart({Key? key, required this.data}) : super(key: key);

  final List<Map<String, dynamic>>? data;

  @override
  _DemographicsChartState createState() => _DemographicsChartState();
}

class _DemographicsChartState extends State<DemographicsChart> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    if (widget.data == null) {
      return Card(
        child: Container(
          width: maxWidth,
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: _headline('Demographics'),
        ),
      );
    }

    Map<String, int> countries = {
      // 'br': 30,
      // 'us': 150,
    };
    for (final info in widget.data!) {
      final code = info['params']['country_code'];
      if (code != null) {
        if (countries.containsKey(code)) {
          countries[code] = countries[code]! + 1;
        } else {
          countries[code] = 1;
        }
      }
    }

    // TODO: Initially, see only 5, but add a button to see all the rest

    int total = 0;
    for (int users in countries.values) {
      total += users;
    }
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        constraints: BoxConstraints(
          // maxHeight: 286.0,
          maxWidth: maxWidth,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headline('Demographics', total),
            ...List.generate(countries.length, (index) {
              final String code = countries.keys.toList()[index];
              final int used = countries[code]!;
              return Stack(alignment: Alignment.centerLeft, children: [
                Container(
                  height: 35,
                  width: maxWidth / (total / used),
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(8.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: FutureBuilder<Country>(
                    future: CountryProvider.getCountryByCode(code),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final country = snapshot.data!;
                        return Row(children: [
                          SizedBox(
                            width: 30,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Flag.fromString(code),
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              country.name ?? code,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${(100 / (total / used)).toStringAsPrecision(5)}%',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(width: 4.0),
                        ]);
                      } else {
                        return WrapWithShimmer(
                          child: Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ]);
            }),
          ],
        ),
      ),
    );
  }
}

class PlatformsChart extends StatefulWidget {
  const PlatformsChart({Key? key, required this.data}) : super(key: key);

  final List<Map<String, dynamic>>? data;

  @override
  _PlatformsChartState createState() => _PlatformsChartState();
}

class _PlatformsChartState extends State<PlatformsChart> {
  static const Map<String, Color> colors = {
    'android': Colors.green,
    'ios': Colors.grey,
    'macos': const Color(0xFF616161),
    'windows': Colors.blue,
    'linux': Colors.orange,
    'web': Colors.black,
  };

  static const Map<String, IconData> icons = {
    'android': Icons.android,
    'ios': Icons.phone_iphone,
    'macos': Icons.laptop,
    'windows': Icons.tab,
    'linux': Icons.desktop_windows,
    'web': Icons.web,
  };

  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final maxWidth = 370.0;

    if (widget.data == null) {
      return Card(
        child: Container(
          width: maxWidth,
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: _headline('Platforms'),
        ),
      );
    }

    Map<String, int> platforms = {
      // 'android': 50,
      // 'ios': 50,
      // 'macos': 10,
      // 'windows': 10,
      // 'linux': 10,
      // 'web': 100,
    };
    for (final info in widget.data!) {
      final code = info['params']['os'];
      if (code != null) {
        if (platforms.containsKey(code)) {
          platforms[code] = platforms[code]! + 1;
        } else {
          platforms[code] = 1;
        }
      }
    }

    int total = 0;
    for (final users in platforms.values) {
      total += users;
    }

    return Card(
      child: Container(
        width: maxWidth,
        margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Column(children: [
          _headline('Platforms', total),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: PieChart(PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: List.generate(platforms.length, (index) {
                        final isTouched = index == touchedIndex;
                        final fontSize = isTouched ? 20.0 : 16.0;
                        final radius = isTouched ? 110.0 : 100.0;
                        final badgeSize = isTouched ? 55.0 : 40.0;

                        final String os = platforms.keys.toList()[index];
                        final int used = platforms[os]!;
                        return PieChartSectionData(
                          color: colors[os],
                          value: used.toDouble(),
                          title: '${(100 / (total / used)).toStringAsFixed(2)}%',
                          radius: radius,
                          titleStyle: TextStyle(fontSize: fontSize),
                          badgeWidget: _Badge(
                            child: Icon(icons[os], color: colors[os]),
                            size: badgeSize,
                            borderColor: const Color(0xfff8b250),
                          ),
                          badgePositionPercentageOffset: .98,
                        );
                      }),
                    )),
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(6, (index) {
                final OSs = [
                  'android',
                  'ios',
                  'macos',
                  'windows',
                  'linux',
                  'web',
                ];
                final os = OSs[index];
                return Indicator(
                  color: colors[os]!,
                  text: os,
                  textColor: Colors.white,
                );
              }),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final double size;
  final Color borderColor;

  final Widget child;

  const _Badge({
    Key? key,
    required this.size,
    required this.borderColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: child),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
