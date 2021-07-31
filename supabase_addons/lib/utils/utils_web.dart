import 'package:intl/intl_browser.dart';

String get operatingSystem => 'web';
Future<String> getSystemLocale() => findSystemLocale();
