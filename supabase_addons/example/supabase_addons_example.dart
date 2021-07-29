import 'dart:async';

import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';

import 'credentials.dart';

void main() async {
  // Intialize the addons
  await SupabaseAddons.initialize(
      client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
      appVersion: '0.1.0');
  SupabaseCrashlyticsAddons.initialize();

  // Run the app
  await runZonedGuarded<Future<void>>(() async {
    if (SupabaseAuthAddons.auth.currentSession == null) {
      print('No user found. Signing the user in');
      await SupabaseAuthAddons.auth.signIn(email: EMAIL, password: PASSWORD);
    } else {
      print('User found on the storage.');
    }

    // throw 'test crashlytics';

    // Dipose the addons
  }, (error, stacktrace) {
    SupabaseCrashlyticsAddons.recordError(error, stacktrace);
  });

  // Dispose the addons
  // SupabaseAddons.dispose();
  // exit(0)
}
