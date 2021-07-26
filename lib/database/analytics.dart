import 'dart:async';
import 'dart:io';

import 'package:supabase/supabase.dart';

import '../supabase_addons.dart';

import '../auth/auth_addons.dart';

/// Implements analytics in Supabase. The analytics addons
///
/// Creating the analytics table:
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
  static bool _isInitialized = false;

  /// Check if the analytics addon is initialized.
  static bool get isInitialized => _isInitialized;

  static late String _analyticsTableName;
  static String get tableName => _analyticsTableName;
  static bool _useLoggedUserInfo = true;

  static StreamSubscription<AuthChangeEvent>? _authListener;

  /// Initialize the analytics addons
  static void initialize({
    String tableName = 'analytics',
    bool useLoggedUserInfo = true,
    bool logUserSignIn = true,
  }) {
    _analyticsTableName = tableName;
    _useLoggedUserInfo = useLoggedUserInfo;
    _isInitialized = true;
    if (logUserSignIn) {
      _authListener = SupabaseAuthAddons.onAuthStateChange.listen((event) {
        if (event == AuthChangeEvent.signedIn) {
          SupabaseAnalyticsAddons.logUserSession();
        }
      });
    }
  }

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
    final response =
        await SupabaseAddons.client.from(_analyticsTableName).insert({
      'name': name.replaceAll(' ', '_'),
      'params': params,
      if (userId != null || _useLoggedUserInfo)
        'user_id': userId ?? SupabaseAuthAddons.auth.currentUser?.id,
      'timestamp': '${DateTime.now().millisecondsSinceEpoch}',
    }).execute();

    if (response.error != null) {
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
    final country_code =
        SupabaseAddons.systemLocale.split('_').last.toLowerCase();
    return logEvent(name: 'user_session', params: {
      'country_code': country_code,
      'os': Platform.operatingSystem,
    });
  }
}
