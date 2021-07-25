/// Support for doing something awesome.
///
/// More dartdocs go here.
library supabase_addons;

import 'package:supabase/supabase.dart';

import 'auth/auth_addons.dart';

class SupabaseAddons {
  const SupabaseAddons._();

  /// The supabase client used
  static late SupabaseClient client;

  /// Initialize the addons
  static void initialize({
    required SupabaseClient client,
    String storagePath = '/',
  }) {
    SupabaseAddons.client = client;
    SupabaseAuthAddons.intialize(storagePath: storagePath);
  }
}
