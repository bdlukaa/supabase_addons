export 'utils/utils_interface.dart'
    if (dart.library.html) 'utils/utils_web.dart'
    if (dart.library.io) 'utils/utils_io.dart';

import 'supabase_addons.dart';

String? getUserCountry() {
  final splitList = SupabaseAddons.systemLocale.split('_');
  String? country_code;
  if (splitList.length >= 2) {
    country_code = splitList[1].toLowerCase();
  }
  return country_code;
}
