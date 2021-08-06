import 'dart:async';

import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';

import '../supabase_addons.dart';

import '../auth/auth_addons.dart';
import '../utils.dart';

/// Implements analytics in Supabase. The analytics addons
///
/// Creating the `analytics` table:
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
  const SupabaseAnalyticsAddons._();

  static bool _isInitialized = false;

  /// Check if the analytics addon is initialized.
  static bool get isInitialized => _isInitialized;

  static String _analyticsTableName = 'analytics';

  /// The table name used by the Analytics Addon. The default table
  /// name is `analytics`
  static String get tableName => _analyticsTableName;
  static bool _useLoggedUserInfo = true;

  static StreamSubscription<AuthChangeEvent>? _authListener;

  /// The user country code.
  ///
  /// This is used by the `user_session` event.
  ///
  /// If not provided when initialized, the country is defined based
  /// on the device language
  static String? userCountry;

  /// Initialize the analytics addons
  static void initialize({
    String tableName = 'analytics',
    bool useLoggedUserInfo = true,
    bool logUserSignIn = true,
    String? userCountry,
  }) {
    if (logUserSignIn) {
      _authListener = SupabaseAuthAddons.onAuthStateChange.listen((event) {
        if (event == AuthChangeEvent.signedIn) {
          SupabaseAnalyticsAddons.logUserSession();
        }
      });
    }

    SupabaseAnalyticsAddons.userCountry = userCountry;
    _analyticsTableName = tableName;
    _useLoggedUserInfo = useLoggedUserInfo;
    _isInitialized = true;
  }

  /// Dispose the addon to free up resources.
  static void dispose() {
    _authListener?.cancel();
  }

  /// Log an event.
  ///
  /// The following information are collected:
  ///
  ///   * The date the event was logged
  ///   * The current user ID, if allowed
  ///   * The user Operational System
  ///   * The user country
  ///
  /// A [PostgrestError] is thrown if the event fails
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? params,
    String? userId,
  }) async {
    assert(
      name.length >= 2,
      'The name must be at least 2 characters long',
    );

    params ??= {};
    params.addAll({
      'country_code': userCountry ?? _getUserCountry(),
      'os': operatingSystem,
    });

    final response =
        await SupabaseAddons.client.from(_analyticsTableName).insert({
      'name': name.replaceAll(' ', '_'),
      'params': params,
      'timestamp': '${DateTime.now().millisecondsSinceEpoch}',
      if (userId != null || _useLoggedUserInfo)
        'user_id': userId ?? SupabaseAuthAddons.auth.currentUser?.id,
    }, returning: ReturningOption.minimal).execute();

    if (response.error != null) {
      print(response.error!.message);
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
    return logEvent(name: 'user_session');
  }

  /// E-Commerce Purchase event. This event signifies that an item(s)
  /// was purchased by a user.
  ///
  /// {@template SupabaseAnalyticsAddons.logPurchase}
  ///
  /// `affiliation`: A product affiliation to designate a supplying
  /// company or brick and mortar store location
  ///
  /// `coupon`: Coupon code used for a purchase
  ///
  /// `currency`: Currency of the purchase or items associated with the
  /// event, in 3-letter [ISO_4217](https://en.wikipedia.org/wiki/ISO_4217#Active_codes)
  /// format. If not provided, the currency is fetched from the device
  ///
  /// `items`: The list of items involved in the transaction
  ///
  /// `shipping`: Shipping cost associated with a transaction
  ///
  /// `tax`: Tax cost associated with a transaction
  ///
  /// `transactionId`: The unique identifier of a transaction
  ///
  /// An [AssertionError] is thrown if the currency couldn't be fetched
  /// {@endTemplate}
  static Future<void> logPurchase({
    String? affiliation,
    String? coupon,
    String? currency,
    List<String> items = const [],
    double? shipping,
    double? tax,
    String? transactionId,
    double? value,
  }) {
    currency ??= NumberFormat.simpleCurrency(
      locale: SupabaseAddons.systemLocale,
    ).currencyName;

    if (value != null || tax != null || shipping != null) {
      assert(
        currency != null,
        'If you supply the value parameter, you must also supply parameter so that revenue metrics can be computed accurately',
      );
    }

    return logEvent(name: 'purchase', params: {
      'affiliation': affiliation,
      'coupon': coupon,
      'currency': currency,
      'items': items,
      'shipping': shipping,
      'tax': tax,
      'transactionId': transactionId,
      'value': value,
    });
  }

  /// E-Commerce Refund event. This event signifies that a refund was issued
  ///
  /// {@macro SupabaseAnalyticsAddons.logPurchase}
  static Future<void> logRefund({
    String? affiliation,
    String? coupon,
    String? currency,
    List<String> items = const [],
    double? shipping,
    double? tax,
    String? transactionId,
    double? value,
  }) {
    currency ??= NumberFormat.simpleCurrency(
      locale: SupabaseAddons.systemLocale,
    ).currencyName;

    if (value != null || tax != null || shipping != null) {
      assert(
        currency != null,
        'If you supply the value parameter, you must also supply parameter so that revenue metrics can be computed accurately',
      );
    }

    return logEvent(name: 'refund', params: {
      'affiliation': affiliation,
      'coupon': coupon,
      'currency': currency,
      'items': items,
      'shipping': shipping,
      'tax': tax,
      'transactionId': transactionId,
      'value': value,
    });
  }

  /// This event signifies when a user sees an ad impression
  ///
  /// `format`: The ad format. (e.g Banner, Native, Rewarded)
  ///
  /// `provider`: The ad provider. (e. g. MoPub, AdMob)
  static Future<void> logAdImpression({
    String? provider,
    String? format,
  }) {
    return logEvent(name: 'ad_impression', params: {
      'format': format,
      'provider': provider,
    });
  }

  /// Screen View event. This event signifies a screen view. Use
  /// this when a screen transition occurs.
  ///
  /// `screenClass`: Current screen class
  ///
  /// `screenName`: Current screen name
  static Future<void> logScreenView({
    String? screenClass,
    String? screenName,
  }) {
    return logEvent(name: 'screen_view', params: {
      'screenClass': screenClass,
      'screenName': screenName,
    });
  }

  /// Search event
  /// 
  /// `term`: The search string/keywords used
  /// 
  /// `params`: contextualize search operations by supplying the appropriate params
  static Future<void> logSearch({
    required String term,
    Map<String, dynamic>? params,
  }) {
    return logEvent(name: 'search', params: {
      'term': term,
      if (params != null) ...params,
    });
  }

  /// Select Item event. This event signifies that an item was selected by a user
  /// from a list. Use the appropriate parameters to contextualize the event. Use
  /// this event to discover the most popular items selected.
  /// 
  /// `item`: the item identifier
  static Future<void> logSelectItem({
    required String item
  }) {
    return logEvent(name: 'select_item', params: {
      'item': item,
    });
  }

  static String? _getUserCountry() {
    final splitList = SupabaseAddons.systemLocale.split('_');
    String? country_code;
    if (splitList.length >= 2) {
      country_code = splitList[1].toLowerCase();
    }
    return country_code;
  }
}
