import 'dart:async';

import 'package:hive/hive.dart';
import 'package:supabase/supabase.dart';

import '../supabase_addons.dart';

const _boxName = 'supabase_authentication';
const _sessionInfoKey = 'session_info';

class SupabaseAuthAddons {
  const SupabaseAuthAddons._();

  /// Get the auth client from the current SupabaseClient
  static GoTrueClient get auth => SupabaseAddons.client.auth;

  static final _authController = StreamController<AuthChangeEvent>.broadcast();

  /// The auth event stream.
  ///
  /// ```dart
  /// SupabaseAuthAddons.onAuthStateChange.listen((event) {
  ///   switch (event) {
  ///     case AuthChangeEvent.signedIn:
  ///       // handle sign in
  ///       break;
  ///     case AuthChangeEvent.signedOut:
  ///       // handle sign out
  ///       break;
  ///     case AuthChangeEvent.userUpdated:
  ///       // handle user updated
  ///       break;
  ///     case AuthChangeEvent.passwordRecovery:
  ///       // handle password recovery
  ///       break;
  ///   }
  /// });
  /// ```
  static Stream<AuthChangeEvent> get onAuthStateChange =>
      _authController.stream;

  /// Intiailize the auth addons.
  ///
  /// This must be called only once on the app
  static Future<void> intialize({required String storagePath}) async {
    Hive.init(storagePath);
    await Hive.openBox(_boxName);
    _initListeners();
    await recoverPersistedSession();
  }

  static void _initListeners() {
    auth.onAuthStateChange((event, session) {
      _authController.add(event);
    });

    onAuthStateChange.listen((event) {
      switch (event) {
        case AuthChangeEvent.userUpdated:
        case AuthChangeEvent.signedIn:
          if (auth.currentSession != null) {
            persistSession();
          }
          break;
        case AuthChangeEvent.signedOut:
          unpersistSession();
          break;
        default:
          break;
      }
    });
  }

  /// Dispose the addon to free up resources.
  ///
  /// The [onAuthStateChange] stream can not be used after this
  /// method is called.
  static void dispose() {
    _authController.close();
  }

  /// Persist the current user session on the disk
  static Future<void> persistSession() {
    assert(auth.currentSession != null, 'There is not session to be persisted');
    final box = Hive.box(_boxName);
    return box.put(_sessionInfoKey, auth.currentSession!.persistSessionString);
  }

  /// Remove the persisted session on the disk
  static Future<void> unpersistSession() {
    final box = Hive.box(_boxName);
    return box.delete(_sessionInfoKey);
  }

  /// Recover the persisted session from disk
  static Future<bool> recoverPersistedSession() async {
    final box = Hive.box(_boxName);
    if (box.containsKey(_sessionInfoKey)) {
      final sessionInfo = box.get(_sessionInfoKey);
      final response = await auth.recoverSession(sessionInfo);
      if (response.error != null) {
        return false;
      } else {
        final valid = response.data is Session;
        if (valid) {
          _authController.add(AuthChangeEvent.signedIn);
        }
        return valid;
      }
    }
    return false;
  }
}
