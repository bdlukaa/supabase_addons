import 'dart:io';

import 'package:intl/intl_standalone.dart';

String get operatingSystem => Platform.operatingSystem;
Future<String> getSystemLocale() => findSystemLocale();