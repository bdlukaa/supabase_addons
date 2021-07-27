/// Support for doing something awesome.
///
/// More dartdocs go here.
library supabase_addons;

import 'package:supabase/supabase.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.html) 'package:intl/intl_browser.dart';

import 'auth/auth_addons.dart';
import 'database/analytics.dart';
import 'database/crashlytics.dart';

export 'auth/auth_addons.dart';
export 'database/analytics.dart';
export 'database/crashlytics.dart';

/// The Supabase Addons
///
/// See also:
///
///   * [SupabaseAuthAddons], the addons to supabase authentication
///   * [SupabaseAnalyticsAddons], an addon that adds analytics to
///     the supabase database.
///   * [SupabaseCrashlyticsAddons], an addon that adds crashlytics
///     to the supabase database.
class SupabaseAddons {
  const SupabaseAddons._();

  /// The supabase client used by the addons.
  static late SupabaseClient client;

  /// The current system locale.
  ///
  /// This is used by the analytics addon to analyze the users country.
  static late String systemLocale;

  /// Initialize some basic addons
  ///
  /// The following addons are initialized on this method:
  ///
  ///   * [SupabaseAuthAddons]
  static Future<void> initialize({
    required SupabaseClient client,
    String authPersistencePath = './auth',
  }) async {
    systemLocale = await findSystemLocale();
    SupabaseAddons.client = client;
    await SupabaseAuthAddons.intialize(storagePath: authPersistencePath);
  }

  /// Dispose all the addons.
  ///
  /// All of them addons are disposed on this method. If they
  /// we not initialized, nothing will happen.
  static void dispose() {
    SupabaseAuthAddons.dispose();
    SupabaseAnalyticsAddons.dispose();
    SupabaseCrashlyticsAddons.dispose();
  }
}
