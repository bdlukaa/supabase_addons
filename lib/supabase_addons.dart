/// Support for doing something awesome.
///
/// More dartdocs go here.
library supabase_addons;

import 'package:supabase/supabase.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.html) 'package:intl/intl_browser.dart';

import 'auth/auth_addons.dart';
import 'database/analytics.dart';

export 'auth/auth_addons.dart';
export 'database/analytics.dart';

class SupabaseAddons {
  const SupabaseAddons._();

  /// The supabase client used
  static late SupabaseClient client;

  static late String systemLocale;

  /// Initialize the addons
  static Future<void> initialize({
    required SupabaseClient client,
    String storagePath = '.',
  }) async {
    systemLocale = await findSystemLocale();
    SupabaseAddons.client = client;
    SupabaseAuthAddons.intialize(storagePath: storagePath);
    SupabaseAnalyticsAddons.initialize();
  }

  static void dispose() {
    SupabaseAuthAddons.dispose();
    SupabaseAnalyticsAddons.dispose();
  }

}
