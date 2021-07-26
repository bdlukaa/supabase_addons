<div>
  <h1 align="center">supabase_addons</h1>
  <p align="center" >
    <a title="Discord" href="https://discord.gg/674gpDQUVq">
      <img src="https://img.shields.io/discord/809528329337962516?label=discord&logo=discord" />
    </a>
    <a title="Pub" href="https://pub.dartlang.org/packages/fluent_ui" >
      <img src="https://img.shields.io/pub/v/fluent_ui.svg?style=popout&include_prereleases" />
    </a>
    <a title="Github License">
      <img src="https://img.shields.io/github/license/bdlukaa/fluent_ui" />
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
- [Analytics](#analytics)
  - [Log an event](#log-an-event)
  - [Auth events](#auth-events)
- [Features and bugs](#features-and-bugs)

# Get started

Import `supabase` and `supabase_addons`:

```dart
import 'package:supabase/supabase.dart';
import 'package:supabase_addons/supabase_addons.dart';
```

First of all, we need to init the addons:

```dart
SupabaseAddons.initialize(
  client: SupabaseClient(SUPABASE_URL, SUPABASE_SECRET),
  storagePath: './auth'
);
```

After eveything is used, you have to dispose the addons. Failure to do so can result in performance issues:

```dart
SupabaseAddons.dispose();
```

## Auth Addons

The auth addon is able to persist the user session into the device storage. It is backed by [hive](https://pub.dev/packages/hive), a lightweight and blazing fast key-value database written in pure Dart

## Analytics

Analytics is a database-addon.

Create a table `analytics` on the server:

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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/bdlukaa/supabase_addons/issues/new
