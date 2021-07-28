import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

import 'constants.dart';
import 'screens/root.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Visualizer',
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
            visualDensity: VisualDensity.standard,
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.label,
        ),
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}
