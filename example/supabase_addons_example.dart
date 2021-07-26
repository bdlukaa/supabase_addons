import 'dart:async';
import 'dart:io';

import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';

import 'credentials.dart';

void main() async {
  // Intialize the addons
  await SupabaseAddons.initialize(
    client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
    storagePath: './auth',
  );
  SupabaseCrashlyticsAddons.initialize();

  // Run the app
  await runZonedGuarded<Future<void>>(() async {
    await SupabaseAuthAddons.auth.signIn(email: EMAIL, password: PASSWORD);

    throw 'test crashlytics';

    // Dipose the addons
  }, (error, stacktrace) {
    SupabaseCrashlyticsAddons.recordError(error, stacktrace);
  });

  // Dispose the addons
  SupabaseAddons.dispose();
  exit(0);
}
