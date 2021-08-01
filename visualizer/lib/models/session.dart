import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';

SupabaseClient? client;

SupabaseClient get loggedClient => client!;
bool get hasClient => client != null;

void signOut() {
  client = null;
}

Future<void> wipeData({DateTime? since}) async {
  PostgrestFilterBuilder query =
      loggedClient.from('analytics').delete(returning: ReturningOption.minimal);
  if (since != null) {
    query = query.lte('analytics', since.millisecondsSinceEpoch);
  }
  final response = await query.execute();
  if (response.error != null) {
    debugPrint(response.error!.message);
    throw response.error!;
  } else {
    debugPrint('data wiped out with success');
  }
}
