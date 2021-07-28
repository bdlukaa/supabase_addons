import 'package:stack_trace/stack_trace.dart';

import '../supabase_addons.dart';

/// Crashlytics is a crash reporter that helps you track,
/// prioritize, and fix stability issues that erode your
/// app quality.
///
/// Create a table called `crashlytics` on the database:
///
/// ```sql
/// create table public.crashlytics (
///   exception text not null,
///   stackTraceElements json,
///   reason text,
///   fatal bool,
///   timestamp text,
///   version text
/// );
/// ```
///
/// Initialize the crashlytics addon:
///
/// ```dart
/// SupabaseCrashlyticsAddons.initialize();
/// ```
class SupabaseCrashlyticsAddons {
  static late String _tableName;

  /// The supabase database table name used by this addon
  static String get tableName => _tableName;

  /// Whether the data collection is enabled. This is usually
  /// disabled when debugging the project, and is only enabled
  /// on production
  static bool collectionEnabled = true;

  const SupabaseCrashlyticsAddons._();

  /// Initiailize the crashlytics addon
  static void initialize({
    bool? collectionEnabled,
    String tableName = 'crashlytics',
  }) {
    SupabaseCrashlyticsAddons.collectionEnabled = collectionEnabled ?? true;
    _tableName = tableName;
  }

  /// Dispose the addon to free up resources
  static void dispose() {
    collectionEnabled = false;
  }

  /// Submits a Crashlytics report of a caught error.
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
    bool printDetails = true,
  }) async {
    if (printDetails) {
      print('----------------CRASHLYTICS----------------');
      if (reason != null) {
        print('The following exception was thrown $reason:');
      }
      print(exception);
      if (stack != null) print('\n$stack');
      print('-------------------------------------------');
    }

    if (!collectionEnabled) return;

    stack ??= StackTrace.current;

    final stackTraceElements = _getStackTraceElements(stack);

    final result = await SupabaseAddons.client.from(tableName).insert({
      'exception': exception.toString(),
      'stacktraceelements': stackTraceElements,
      'reason': reason,
      'fatal': fatal,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'version': SupabaseAddons.appVersion,
    }).execute();

    if (result.error != null) {
      print(result.error!.message);
      throw result.error!;
    }
  }
}

final _obfuscatedStackTraceLineRegExp =
    RegExp(r'^(\s*#\d{2} abs )([\da-f]+)((?: virt [\da-f]+)?(?: .*)?)$');

/// Returns a [List] containing detailed output of each line in a stack trace.
List<Map<String, String>> _getStackTraceElements(StackTrace stackTrace) {
  final trace = Trace.parseVM(stackTrace.toString()).terse;
  final elements = <Map<String, String>>[];

  for (final frame in trace.frames) {
    if (frame is UnparsedFrame) {
      if (_obfuscatedStackTraceLineRegExp.hasMatch(frame.member)) {
        // Same exceptions should be grouped in Crashlytics Console.
        // Crashlytics Console groups issues with same stack trace.
        // Obfuscated stack traces contains abs address, virt address
        // and symbol name + offset. abs addresses are different across
        // sessions, so same error can create different issues in Console.
        // We replace abs address with '0' so that Crashlytics Console can
        // group same exceptions. Also we don't need abs addresses for
        // deobfuscating, if we have virt address or symbol name + offset.
        final method = frame.member.replaceFirstMapped(
            _obfuscatedStackTraceLineRegExp,
            (match) => '${match.group(1)}0${match.group(3)}');
        elements.add(<String, String>{
          'file': '',
          'line': '0',
          'method': method,
        });
      }
    } else {
      final element = <String, String>{
        'file': frame.library,
        'line': frame.line?.toString() ?? '0',
      };
      final member = frame.member ?? '<fn>';
      final members = member.split('.');
      if (members.length > 1) {
        element['method'] = members.sublist(1).join('.');
        element['class'] = members.first;
      } else {
        element['method'] = member;
      }
      elements.add(element);
    }
  }

  return elements;
}
