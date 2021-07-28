<div>
  <h1 align="center">supabase_addons</h1>
  <p align="center" >
    <a title="Discord" href="https://discord.gg/674gpDQUVq">
      <img src="https://img.shields.io/discord/809528329337962516?label=discord&logo=discord" />
    </a>
    <a title="Pub" href="https://pub.dartlang.org/packages/supabase_addons" >
      <img src="https://img.shields.io/pub/v/supabase_addons.svg?style=popout&include_prereleases" />
    </a>
    <a title="Github License">
      <img src="https://img.shields.io/github/license/bdlukaa/supabase_addons" />
    </a>
    <a title="PRs are welcome">
      <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" />
    </a>
  </p>
  <p align="center">
  Make great apps with a great backend!
  </p>
</div>

Supabase is an open source Firebase alternative. It has support for auth, database and storage updates. The goal of this package is to make things easier when using supabase.

- [Get started](#get-started)
- [Auth Addons](#auth-addons)
  - [How it works?](#how-it-works)
  - [Change the storage path](#change-the-storage-path)
- [Analytics](#analytics)
  - [Getting started](#get-started-with-analytics)
  - [Log an event](#log-an-event)
  - [Auth events](#auth-events)
- [Crashlytics](#crashlytics)
  - [Getting started](#get-started-with-crashlytics)
  - [Toggle collection](#toggle-collection)
  - [Recording an error](#recording-an-error)
  - [Handling uncaught errors](#handling-uncaught-errors)
- [Features and bugs](#features-and-bugs)

# Get started

Add the dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  supabase: <latest-version>
  supabase_addons: <latest-version>
```

Import both `supabase` and `supabase_addons`:

```dart
import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';
```

First of all, we need to init the addons:

```dart
await SupabaseAddons.initialize(
  client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
);
```

After eveything is used, you have to dispose the addons. Failure to do so can result in performance issues:

```dart
SupabaseAddons.dispose();
```

## Auth Addons

The auth addon is able to persist the user session into the device storage. It is backed by [hive](https://pub.dev/packages/hive), a lightweight and blazing fast key-value database written in pure Dart

### How it works?

The user session is persisted on the device everytime the user signs in or is updated. When the user signs out, the session is removed from the device.

This behavior is enabled by default when `SupabaseAddons.initialize` is called. To disable it, call `SupabaseAuthAddons.dispose()`. Once disabled, it can't be turned on anymore

### Change the storage path

When initializing the addons, you can change the `storagePath` to the location you'd like:

```dart
SupabaseAddons.initialize(
  ...,
  authPersistencePath: './auth'
);
```

If you're in a Flutter environment, you can use the package [path_provider](https://pub.dev/packages/path_provider) to get the application documents path:

```dart
import 'package:path_provider/path_provider.dart';

final dir = await getApplicationDocumentsDirectory()

SupabaseAddons.initialize(
  ...,
  authPersistencePath: '${dir.path}/auth'
);
```

## Analytics

Analytics is a database-addon.

Analytics provides insight on app usage and user engagement. Its reports help you understand clearly how your users behave, which enables you to make informed decisions regarding app marketing and performance optimizations.

### Get started with Analytics

Create a table called `analytics` on the database:

```sql
create table public.analytics (
  name text not null,
  params json,
  user_id text,
  timestamp text
);
```

Initialize the analytics addon:

```dart
SupabaseAnalyticsAddons.initialize();
```

### Log an event

After initialized, you can log the events using `SupabaseAnalyticsAddons.logEvent`.

You can pass three arguments:

- **required** `name`, the event name. It can't have any spaces. If any, they are replaced by `_`.
- `params`, the event info. It's not required to have params, but it's good to have when rendering the graphics. The more info, the better
- `userId`, the user id on the event. If not provided, the current session is used

```dart
SupabaseAnalyticsAddons.logEvent('goal_completion', params: {
  'name': 'lever_puzzle',
});
```

### Auth events

When the user is signed in or signed up, the `user_session` event is triggered automatically.

> You can disable the automatic logging when initializing by passing `logUserSignIn: false`.

The `user_session` has some useful information on the params field:

- `country_code`, the user country.
- `os`, the user operating system. This is a `String` representing the operating system or platform. This is powered by (`Platform.operatingSystem`)

## Crashlytics

Crashlytics is a crash reporter that helps you track, prioritize, and fix stability issues that erode your app quality.

### Get started with Crashlytics

Create a table called `crashlytics` on the database:

```sql
create table public.crashlytics (
  exception text not null,
  stackTraceElements json,
  reason text,
  fatal bool,
  timestamp text,
  version text
);
```

Initialize the crashlytics addon:

```dart
SupabaseCrashlyticsAddons.initialize();
```

### Toggle Collection

```dart
import 'package:flutter/foundation.dart' show kDebugMode;

if (kDebugMode) {
  // Force disable collection while doing every day development.
  // Temporarily toggle this to true if you want to test crash reporting in your app.
  SupabaseCrashlyticsAddons.collectionEnabled = false;
} else {
  // Handle Crashlytics enabled status when not in Debug,
  // e.g. allow your users to opt-in to crash reporting.
}
```

### Recording an error

To record an error with custom information, you can wrap the code in a try/catch block:

```dart
import 'package:flutter/foundation.dart' show kDebugMode;

try {
  // code that may throw an exception
} catch (error, stacktrace) {
  SupabaseCrashlyticsAddons.recordError(
    error,
    stacktrace,
    reason: 'The user is very dumb', // the reason goes here
    fatal: false, // whether the error is fatal, such as an app crash
    printDetails: kDebugMode, // whether the error should be printed to the console. Usually only on debug mode
  );
}
```

### Handling uncaught errors

If you're using Flutter, you can catch and report all the errors from the framework by redefining `FlutterError.onError` with the following function:

```dart
FlutterError.onError = (details) {
  FlutterError.dumpErrorToConsole(details, forceReport: true);

  SupabaseCrashlyticsAddons.recordError(
    details.exceptionAsString(),
    details.stack,
    reason: details.context,
    printDetails: false,
  );
}
```

To catch any other exception that may happen in your program, wrap the dart program in a `runZonedGuarded`:

```dart
void main() async {
  runZonedGuarded<Future<void>>(() async {
    // the rest of your code goes here
    runApp(MyApp());
  }, (error, stacktrace) {
    SupabaseCrashlyticsAddons.recordError(error, stacktrace);
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/bdlukaa/supabase_addons/issues/new
