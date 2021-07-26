import 'dart:io';

import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';

import 'credentials.dart';

void main() async {
  // Intialize the addons
  await SupabaseAddons.initialize(
    client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
    storagePath: './auth'
  );
  await SupabaseAuthAddons.auth.signIn(email: EMAIL, password: PASSWORD);

  // Dipose the addons
  SupabaseAddons.dispose();

  exit(0);
}
