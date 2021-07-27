import 'package:supabase/supabase.dart';

SupabaseClient? client;

SupabaseClient get loggedClient => client!;
bool get hasClient => client != null;