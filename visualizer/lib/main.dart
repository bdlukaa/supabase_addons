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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            visualDensity: VisualDensity.standard,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.standard,
          ),
        ),
        tabBarTheme: TabBarTheme(indicatorSize: TabBarIndicatorSize.label),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
