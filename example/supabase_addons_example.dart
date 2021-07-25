import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';

import 'credentials.dart';

void main() async {
  await SupabaseAddons.initialize(
    client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
  );
  final response = await SupabaseAuthAddons.auth.signIn(
    email: EMAIL,
    password: PASSWORD,
  );
  SupabaseStatisticsPrinter().printStatistics(DateTime.now().subtract(Duration(days: 3)));
}
