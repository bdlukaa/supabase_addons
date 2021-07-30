import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';

/// The addons helper for Flutter
///
/// Usage:
///
/// ```dart
/// void main() async {
///   await SupabaseAddonsFlutter.initialize(client);
///   runApp(MyApp());
/// }
/// ```
class SupabaseAddonsFlutter {
  /// Initialize the Supabase Addons
  ///
  /// It automatically defines the Auth Persistent Storage location
  /// and the App Version (used by analytics), if not provided.
  static Future<void> initialize({
    required SupabaseClient client,
    String? authPersistencePath,
    String? appVersion,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    // The documents directory is where the user auth information is going
    // to be stored
    final persistencePath = authPersistencePath ??
        await () async {
          final documentsDir = await getApplicationDocumentsDirectory();
          return '${documentsDir.path}/auth';
        }();

    // Get the current app info. This is used by analytics to determine the
    // current app version
    final version = appVersion ?? (await PackageInfo.fromPlatform()).version;

    return SupabaseAddons.initialize(
      client: client,
      authPersistencePath: persistencePath,
      appVersion: version,
    );
  }
}
