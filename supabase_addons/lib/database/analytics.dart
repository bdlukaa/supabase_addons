import 'dart:async';

import 'package:supabase/supabase.dart';

import '../supabase_addons.dart';

import '../auth/auth_addons.dart';
import '../utils.dart';

/// Implements analytics in Supabase. The analytics addons
///
/// Creating the `analytics` table:
///
/// ```sql
/// create table public.analytics (
///   name text not null,
///   params json,
///   user_id text,
///   timestamp text
/// );
/// ```
class SupabaseAnalyticsAddons {
  const SupabaseAnalyticsAddons._();

  static bool _isInitialized = false;

  /// Check if the analytics addon is initialized.
  static bool get isInitialized => _isInitialized;

  static String _analyticsTableName = 'analytics';

  /// The table name used by the Analytics Addon. The default table
  /// name is `analytics`
  static String get tableName => _analyticsTableName;
  static bool _useLoggedUserInfo = true;

  static StreamSubscription<AuthChangeEvent>? _authListener;

  /// The user country code.
  ///
  /// This is used by the `user_session` event.
  ///
  /// If not provided when initialized, the country is defined based
  /// on the device language
  static String? userCountry;

  /// Initialize the analytics addons
  static void initialize({
    String tableName = 'analytics',
    bool useLoggedUserInfo = true,
    bool logUserSignIn = true,
    String? userCountry,
  }) {
    if (logUserSignIn) {
      _authListener = SupabaseAuthAddons.onAuthStateChange.listen((event) {
        if (event == AuthChangeEvent.signedIn) {
          SupabaseAnalyticsAddons.logUserSession();
        }
      });
    }

    SupabaseAnalyticsAddons.userCountry = userCountry;
    _analyticsTableName = tableName;
    _useLoggedUserInfo = useLoggedUserInfo;
    _isInitialized = true;
  }

  /// Dispose the addon to free up resources.
  static void dispose() {
    _authListener?.cancel();
  }

  /// Log an event
  ///
  /// A [PostgrestError] is thrown if the event fails
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic> params = const {},
    String? userId,
  }) async {
    assert(
      name.length >= 2,
      'The name must be at least 2 characters long',
    );

    final response =
        await SupabaseAddons.client.from(_analyticsTableName).insert({
      'name': name.replaceAll(' ', '_'),
      'params': params,
      'timestamp': '${DateTime.now().millisecondsSinceEpoch}',
      if (userId != null || _useLoggedUserInfo)
        'user_id': userId ?? SupabaseAuthAddons.auth.currentUser?.id,
    }, returning: ReturningOption.minimal).execute();

    if (response.error != null) {
      print(response.error!.message);
      throw response.error!;
    }
  }

  /// Log when a user signs in the app.
  ///
  /// This event is usually triggered when:
  ///
  ///   * The user signs in
  ///   * The user signs up
  ///
  /// This can be useful to check where the users mostly use your app.
  static Future<void> logUserSession() {
    return logEvent(name: 'user_session', params: {
      'country_code': userCountry ?? _getUserCountry(),
      'os': operatingSystem,
    });
  }

  static String? _getUserCountry() {
    final splitList = SupabaseAddons.systemLocale.split('_');
    String? country_code;
    if (splitList.length >= 2) {
      country_code = splitList[1].toLowerCase();
    }
    return country_code;
  }
}
