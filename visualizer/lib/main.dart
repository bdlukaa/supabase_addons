import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

import 'constants.dart';
import 'screens/root.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Visualizer',
      initialRoute: '/',
      routes: {
        '/': (_) => Root(),
      },
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: kPrimaryColor,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kPrimaryColor,
        indicatorColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        tabBarTheme: TabBarTheme(indicatorSize: TabBarIndicatorSize.label),
        visualDensity: VisualDensity.standard,
        tooltipTheme: TooltipThemeData(
          height: 32.0,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
